require 'rails_helper'

describe 'API Authentication', :type => :api do

  let(:user_params) { FactoryGirl.attributes_for(:user) }
  let(:invalid_user_params) {
    [:user_without_email, :user_without_first_name, :user_without_last_name].map do |user|
      FactoryGirl.attributes_for(user)
    end
  }

  context 'Registration' do
    it 'should successfully register new user with valid params' do
      expect {
        post '/register', { format: :json, user: user_params }
        expect(last_response.status).to be(201)
        expect(last_response.body).to be_empty
      }.to change{ User.count }.by(1)
    end

    it 'should fail to register new user with invalid params' do
      expect {
        invalid_user_params.each do |invalid_params|
          post '/register', { format: :json, user: invalid_params }
          expect(last_response.status).to be(422)
          expect(body = json(last_response.body)).to_not be_empty
          expect(body.length).to be(1)
        end
      }.not_to change{ User.count }
    end
  end

  context 'Confirmation' do

    let (:user) { FactoryGirl.create(:user) }
    let (:conf_token) { user.confirmation_token }
    let (:false_token) {
      while true
        token = SecureRandom.hex(32)
        break token unless token.eql?(conf_token)
      end
    }

    it 'should successfully confirm new user with valid token' do
      get "/confirm/#{Rack::Utils.escape(user.email)}/#{conf_token}", { format: :json }
      expect(user.reload.confirmed_at).to be_within(10.seconds).of(Time.now)
      expect(last_response.status).to be(200)
      expect(last_response.body).to be_empty
    end

    it 'should not confirm new user with invalid token' do
      get "/confirm/#{Rack::Utils.escape(user.email)}/#{false_token}", { format: :json }
      expect(user.reload.confirmed_at).to be_nil
      expect(last_response.status).to be(422)
      expect(body = json(last_response.body)).to_not be_empty
      expect(body[:token]).to eq("invalid")
    end
  end

end
