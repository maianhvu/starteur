require 'rails_helper'

describe 'API Query Interface', :type => :api do

  let!(:user) {
    u = FactoryGirl.create(:user)
    u.confirm!(u.confirmation_token)
    u
  }

  let!(:request_params) { { :format => :json, :user => { email: user.email } } }

  let(:auth_token) {
    token = user.authentication_tokens.in_use.first
    unless token
      token = user.authentication_tokens.fresh.first || AuthenticationToken.create!(user: user)
      token.use!
    end
    token.token
  }

  let(:false_token) {
    while true
      token = SecureRandom.hex(32)
      break token unless token.eql?(auth_token)
    end
  }

  let(:expired_token) { auth_token.expire! }

  shared_examples_for "any request" do
    context "CORS Requests" do
      it "should set the Access-Control-Allow-Origin header to allow CORS from anywhere" do
        expect(last_response.headers['Access-Control-Allow-Origin']).to eq('*')
      end

      it "should allow general HTTP methods thru CORS (GET/POST/PUT/DELETE)" do
        allowed_http_methods = last_response.header['Access-Control-Allow-Methods']
        %w{GET POST PUT DELETE}.each do |method|
          expect(allowed_http_methods).to include(method)
        end
      end

    end
  end

  describe "HTTP OPTIONS requests" do
    before(:each) do
      token_header auth_token
      options '/profile', request_params
    end

    it_should_behave_like "any request"

    it "should be succesful" do
      expect(last_response.status).to be(200)
    end
  end

  context 'Authentication Token Management' do
    let!(:test) { FactoryGirl.create(:test) }

    it 'should allow fresh and in_use tokens' do
      [:fresh, :in_use].each do |token_state|
        token = FactoryGirl.build("#{token_state.to_s}_auth_token".to_sym)
        token.user = user
        token.save!
        token_header token.token
        get "/tests", request_params
        expect(last_response.status).to be(200)
      end
    end

    it 'should not allow expired tokens' do
      token = FactoryGirl.build(:expired_auth_token)
      token.user = user
      token.save!
      token_header token.token
      get "/tests", request_params
      expect(last_response.status).to be(401)
      expect(last_response.body).to_not be_empty
      expect((body = json(last_response.body)).length).to be(2)
      expect(body).to have_key(:errors)
      expect(body[:errors]).to eq('Expired token')
      expect(body).to have_key(:errorFields)
      expect(body[:errorFields]).to be_empty
    end

    it 'should not allow bogus tokens' do
      token = SecureRandom.hex(32)
      token_header token
      get "/tests", request_params
      expect_authentication_failed
    end

  end

  context 'Tests' do

    before(:each) do
      # Create published tests
      10.times do
        while true
          attrib = FactoryGirl.attributes_for(:faked_test)
          break attrib if Test.new(attrib).valid?
        end
        Test.create!(attrib)
      end
      # Create unpublished tests
      3.times do
        while true
          attrib = FactoryGirl.attributes_for(:faked_unpublished_test)
          break attrib if Test.new(attrib).valid?
        end
        Test.create!(attrib)
      end
    end

    it 'should get only published tests with valid authentication' do
      token_header auth_token
      get '/tests', request_params
      expect(last_response.status).to be(200)
      expect(last_response.body).to_not be_empty
      expect((body = json(last_response.body)).length).to eq(10)
      body.each do |test_data|
        expect(test_data).to have_key(:id)
      end
    end

    it 'should FAIL to get tests with invalid authentication' do
      token_header false_token
      get '/tests', request_params
      expect_authentication_failed
    end

    it 'should get correct statuses for each tests' do
      Test.published.limit(4).all.each do |test|
        code = FactoryGirl.create(:access_code, test: test)
        CodeUsage.create!(access_code: code, user: user)
      end
      token_header auth_token
      get '/tests', request_params
      body = json(last_response.body)
      body.each do |test|
        expect(test).to have_key(:status)
      end
      expect(body.select { |t| t[:status][:purchased] }.count).to be(4)
    end

    it 'should have an access code attached to the purchased test' do
      test1 = Test.published.first
      code = FactoryGirl.create(:access_code, test: test1)
      usage = CodeUsage.create!(access_code: code)
      usage.use!(user)
      token_header auth_token
      get '/tests', request_params
      body = json(last_response.body).first
      expect(body).to have_key(:accessCode)
      expect(body[:accessCode]).to eq(code.code)
    end

  end

  context 'Questions and Answers' do
    let!(:test) { FactoryGirl.create(:test) }
    let!(:categories) {
      4.times do
        c = FactoryGirl.build(:category)
        c.test = test
        c.save!
      end
      test.categories
    }

    before(:each) do
      (1..20).each do |n|
        q = FactoryGirl.build(:question)
        q.category = categories[n%4]
        q.save!
      end
    end

    context 'Questions' do

      let!(:access_code) { FactoryGirl.create(:access_code, test: test) }
      let!(:usage) {
        usage1 = CodeUsage.create!(access_code: access_code)
        usage1.use!(user)
        usage1
      }

      let(:question_params) {
        params1 = request_params
        params1[:accessCode] = access_code.code
        params1
      }

      it 'should get the test\'s questions with valid authentication' do
        token_header auth_token
        get "/tests/#{test.id}/questions", question_params
        expect(last_response.status).to be(200)
        expect(last_response.body).to_not be_empty
        expect((body = json(last_response.body)).length).to eq(20)
        body.each do |question|
          expect(question).to have_key(:choices)
          expect(question[:choices].length).to be(3)
        end
      end

      it 'should FAIL to get the test\'s questions with invalid authentication' do
        token_header false_token
        get "/tests/#{test.id}/questions", request_params
        expect_authentication_failed
      end

      it 'should only return unanswered questions' do
        # Prepare answered questions
        test.questions.limit(4).each do |q|
          Answer.create!(question: q, user: user, test: test, value: 1)
        end
        # Start querying
        token_header auth_token
        get "/tests/#{test.id}/questions", question_params
        expect((body = json(last_response.body)).length).to be(20-4)
        # Ensure returned questions are unanswered
        # Answered Questions IDs
        aq_ids = user.answers.map(&:question_id)
        body.each do |question|
          expect(aq_ids).to_not include(question)
        end
      end

      it 'should order questions by categories\' ranks' do
        token_header auth_token
        get "/tests/#{test.id}/questions", question_params
        body = json(last_response.body)
        previous_category_rank = nil
        body.each do |question|
          category_rank = Question.find(question[:id]).category.rank
          expect(category_rank).to be >= previous_category_rank if previous_category_rank
          previous_category_rank = category_rank
        end
      end
    end

    context 'Answers' do
      let!(:questions) { test.questions.limit(4) }
      let!(:answer_params) {
        answers = {}
        questions.each do |q|
          answers[q.id] = rand(7)
        end
        { format: :json, user: { email: user.email }, answers: answers }
      }
      let!(:access_code) { FactoryGirl.create(:access_code, test: test) }

      shared_examples "single-use access codes" do

        let!(:code_usage) {
          usage = CodeUsage.create!(access_code: access_code)
          usage.use!(user)
          usage
        }

        it 'should be able to add new answers' do
          expect {
            token_header auth_token
            post "/tests/#{test.id}/answers", answer_params
            expect(last_response.status).to be(200)
          }.to change { user.answers.count }.by(4)
        end

        it 'should return answered question ids' do
          token_header auth_token
          post "/tests/#{test.id}/answers", answer_params
          expect(last_response.body).to_not be_empty
          expect(body = json(last_response.body)).to have_key(:question_ids)
          expect(body[:question_ids]).to eq(questions.map(&:id))
        end

        it 'should return completion status' do
          token_header auth_token
          post "/tests/#{test.id}/answers", answer_params
          expect(body = json(last_response.body)).to have_key(:completed)
          expect(body).to have_key(:completed)
          expect(body[:completed]).to be_falsy

          # Questions still left unanswered
          leftover = test.questions.where('questions.id NOT IN (?)', body[:question_ids])
          answers = {}
          leftover.each do |qn|
            answers[qn.id] = rand(7)
          end
          new_params = {
            format: :json,
            :user => { email: user.email },
            answers: answers
          }
          post "/tests/#{test.id}/answers", new_params
          expect(body = json(last_response.body)).to have_key(:completed)
          expect(body[:completed]).to be_truthy
        end

        it 'should create a result object upon finishing a test' do
          expect {
            answers = {}
            test.questions.each do |qn|
              answers[qn.id] = rand(7)
            end
            finish_params = {
              :format => :json,
              :user   => { email: user.email },
              :answers => answers
            }
            token_header auth_token
            post "/tests/#{test.id}/answers", finish_params
            expect(last_response.status).to be(200)
          }.to change { test.results.count }.by(1)
            .and change { user.results.count }.by(1)
          # Expect temporary answers to get wiped
          expect(user.answers.where(test: test).count).to be(0)
        end
      end

      describe 'Using Single-use access code' do
        include_examples "single-use access codes"
      end

      describe 'Using Universal access code' do
        let!(:access_code) { FactoryGirl.create(:universal_access_code, test: test) }
        it_should_behave_like "single-use access codes"

        it 'should create multiple code usages under the same access code' do
          # Create 5 different user and let all 5 use the same code
          expect {
            5.times do
              u = FactoryGirl.create(:user)
              u.confirm!(u.confirmation_token)
              token = u.authentication_tokens.fresh.first || AuthenticationToken.create!(user: u)
              token.use!
              token_header token.token
              get "/tests/#{test.id}/use-code/#{access_code.code}", { format: :json, user: { email: u.email } }
              expect(last_response.status).to be(201)
            end
          }.to change { CodeUsage.count }.by(5)
            .and change { AccessCode.count }.by(0)
        end
      end
    end
  end

  # Dashboard
  context 'Dashboard' do

    context 'Profile' do
      let!(:keys) { [:email, :first_name, :last_name, :confirmed] }
      it 'should retrieve profile with valid auth token' do
        token_header auth_token
        get "/profile", request_params
        expect(last_response.status).to be(200)
        expect(last_response.body).to_not be_empty
        body = json(last_response.body)
        keys.each do |key|
          expect(body).to have_key(key)
          expect(body[key]).to_not be_nil
        end
      end

      it 'should not retrieve profile with invalid auth token' do
        token_header false_token
        get "/profile", request_params
        expect_authentication_failed
      end
    end
  end

  context 'Purchases and Access Codes' do
    let!(:test) { FactoryGirl.create(:faked_test) }
    let!(:access_code) { FactoryGirl.create(:access_code, test: test) }
    let!(:universal_access_code) { FactoryGirl.create(:universal_access_code, test: test) }

    shared_examples "single-use access codes" do
      it 'should create a code usage when user locks in access code' do
        expect {
          token_header auth_token
          get "/tests/#{test.id}/use-code/#{access_code.code}", request_params
          expect(last_response.status).to be(201)
          expect(last_response.body).to be_empty
        }.to change { CodeUsage.count }.by(1)
        usage = CodeUsage.last
        expect(usage).to be_used
        expect(usage.user).to eq(user)
        expect(usage.access_code).to eq(access_code)
        expect(usage.access_code.test).to eq(test)
      end

      it 'should FAIL to let the user lock in an invalid access code' do
        # Bogus code
        while true
          bogus_code = SecureRandom.hex(32)
          break bogus_code unless bogus_code.equal?(access_code)
        end
        while true
          test2 = FactoryGirl.build(:faked_test)
          break test2 if test2.valid?
        end
        test2.save!
        code2 = FactoryGirl.create(:access_code, test: test2)
        [bogus_code, code2.code].each do |code|
          expect {
            token_header auth_token
            get "/tests/#{test.id}/use-code/#{code}", request_params
            expect(last_response.status).to be(422)
            expect(last_response.body).to_not be_empty
            expect((body = json(last_response.body)).length).to be(1)
            expect(body).to have_key(:errors)
            expect(body[:errors]).to include('Invalid access code')
          }.to_not change { CodeUsage.count }
        end
      end
    end

    describe "Using Single-use access codes" do
      include_examples "single-use access codes"

      it 'should FAIL to let user reuse a Single-use code' do
        2.times do
          token_header auth_token
          get "/tests/#{test.id}/use-code/#{access_code.code}", request_params
        end
        expect(last_response.status).to be(422)
      end
    end

    describe "Using Universal access codes" do
      it_should_behave_like "single-use access codes"
    end
  end

  context 'Results from Tests' do
    let!(:test) { FactoryGirl.create(:published_test) }
    let!(:categories) {
      cs = []
      (0..11).each do |i|
        cs << FactoryGirl.create(:category, test: test, rank: (i%4)+1)
      end
      cs
    }
    let!(:questions) {
      qs = []
      (0..119).each do |i|
        qs << FactoryGirl.create(:question, category: categories[i%12])
      end
      qs
    }
    let!(:access_code) {
      FactoryGirl.create(:access_code, test: test)
    }
    let!(:usage) {
      u = CodeUsage.create!(access_code: access_code)
      u.use!(user)
      u
    }

    it 'should retrieve test results using correct auth token' do
      # First, answer all questions
      answer_params = request_params
      answer_params[:answers] = {}

      # Manipulate scores
      min = 1
      max = 3
      questions.each do |question|
        if question.category.rank <= 3
          score = min + rand(max + 1 - min)
          answer_params[:answers][question.id] = score
        else
          answer_params[:answers][question.id] = rand(2)
        end
      end
      token_header auth_token
      post "/tests/#{test.id}/answers", answer_params
      # Now, get the result
      token_header auth_token
      get "/tests/#{test.id}/results", request_params
      expect(last_response.status).to be(200)
      expect(last_response.body).to_not be_empty
    end
  end

end
