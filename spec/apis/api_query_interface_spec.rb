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
      expect((body = json(last_response.body)).length).to be(1)
      expect(body[:errors]).to include('Expired token')
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
    end

    it 'should FAIL to get tests with invalid authentication' do
      token_header false_token
      get '/tests', request_params
      expect_authentication_failed
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

        # Create choices
        3.times do
          while true
            c = FactoryGirl.build(:choice)
            c.question = q
            break c if c.valid?
          end
          c.save!
        end
      end
    end

    context 'Questions' do

      it 'should get the test\'s questions with valid authentication' do
        token_header auth_token
        get "/tests/#{test.id}/questions", request_params
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
          Answer.create!(choice: q.choices.first, user: user, test: test)
        end
        # Start querying
        token_header auth_token
        get "/tests/#{test.id}/questions", request_params
        expect((body = json(last_response.body)).length).to be(20-4)
        # Ensure returned questions are unanswered
        # Answered Questions IDs
        aq_ids = user.answers.map(&:choice).map(&:question_id)
        body.each do |question|
          expect(aq_ids).to_not include(question)
        end
      end

      it 'should return completion status' do

      end

      it 'should order questions by categories\' ranks' do
        token_header auth_token
        get "/tests/#{test.id}/questions", request_params
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
        answers = []
        questions.each do |q|
          answers << q.choices.first.id
        end
        { format: :json, user: { email: user.email }, answers: answers }
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
        new_params = {
          format: :json,
          :user => { email: user.email },
          answers: leftover.map(&:choices).map(&:first).map(&:id)
        }
        post "/tests/#{test.id}/answers", new_params
        expect(body = json(last_response.body)).to have_key(:completed)
        expect(body[:completed]).to be_truthy
      end

      it 'should create a result object upon finishing a test' do
        expect {
          finish_params = {
            :format => :json,
            :user   => { email: user.email },
            :answers => test.questions.map(&:choices).map(&:first).map(&:id)
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
  end

  # Dashboard
  context 'Dashboard' do

    context 'Profile' do
      let!(:keys) { [:email, :first_name, :last_name, :confirmed] }
      it 'should retrieve profile with valid auth token' do
        token_header auth_token
        get '/profile', request_params
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
        get '/profile', request_params
        expect_authentication_failed
      end
    end
  end

end
