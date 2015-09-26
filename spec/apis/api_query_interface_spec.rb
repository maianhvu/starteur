require 'rails_helper'

describe 'API Query Interface', :type => :api do

  let!(:user) {
    u = FactoryGirl.create(:user)
    u.confirm!(u.confirmation_token)
    u
  }

  let(:auth_token) {
    token = user.authentication_tokens.in_use.first
    unless token
      token = user.authentication_tokens.fresh.first || AuthenticationToken.create!(user: user)
      token.use!
    end
    token.token
  }

  context 'Test' do

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
      get '/tests', { :format => :json, :user => { :email => user.email } }
      expect(last_response.status).to be(200)
      expect(last_response.body).to_not be_empty
      expect((body = json(last_response.body)).length).to eq(10)
    end

    it 'should fail to get tests with invalid authentication' do
      while true
        false_token = SecureRandom.hex(32)
        break false_token unless false_token.eql?(auth_token)
      end
      token_header false_token
      get '/tests', { :format => :json, :user => { :email => user.email } }
      expect(last_response.status).to be(401)
      expect(last_response.body).to_not be_empty
      expect((body = json(last_response.body)).length).to eq(1)
      expect(body[:errors]).to include('Bad credentials')
    end

  end



end
