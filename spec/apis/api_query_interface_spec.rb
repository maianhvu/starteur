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

  context 'Questions' do
    let!(:test) { FactoryGirl.create(:test) }

    before(:each) do
      10.times do
        q = FactoryGirl.build(:question)
        q.test = test
        q.save!
      end
    end

    it 'should get the test\'s questions with valid authentication' do
      token_header auth_token
      get "/tests/#{test.id}/questions", request_params
      expect(last_response.status).to be(200)
      expect(last_response.body).to_not be_empty
      expect((body = json(last_response.body)).length).to eq(10)
    end

    it 'should FAIL to get the test\'s questions with invalid authentication' do
      token_header false_token
      get "/tests/#{test.id}/questions", request_params
      expect_authentication_failed
    end
  end

end
