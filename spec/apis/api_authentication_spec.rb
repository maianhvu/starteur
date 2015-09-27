require 'rails_helper'

describe 'API Authentication', :type => :api do

  let(:user_params) { FactoryGirl.attributes_for(:user) }
  let(:invalid_user_params) {
    [:email, :first_name, :last_name].map do |attrib|
      FactoryGirl.attributes_for(:user, { attrib => nil })
    end
  }

  context 'Registration' do
    it 'should successfully register new user with valid params' do
      expect {
        post '/register', { format: :json, user: user_params }
        expect(last_response.status).to be(201)
        expect(last_response.body).to_not be_empty
        expect((body = json(last_response.body)).length).to be(1)
        expect(body).to have_key(:user)
        expect(body[:user]).to have_key(:first_name)
        expect(body[:user][:first_name]).to_not be_empty
        expect(body[:user]).to have_key(:email)
        expect(body[:user][:email]).to_not be_empty
      }.to change{ User.count }.by(1)
    end

    it 'should fail to register new user with invalid params' do
      expect {
        invalid_user_params.each do |invalid_params|
          post '/register', { format: :json, user: invalid_params }
          expect(last_response.status).to be(422)
          expect(last_response.body).to_not be_empty
          expect(json(last_response.body).length).to be(1)
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
      expect(last_response.body).to_not be_empty
      expect(json(last_response.body)[:errors]).to include("Invalid confirmation token")
    end
  end

  context 'Authentication' do
    let!(:user) { FactoryGirl.create(:user) }
    let(:confirmed_user) { user.confirm!(user.confirmation_token) && user }
    let(:valid_token) { Proc.new { |token| confirmed_user.authentication_tokens.find_by(token: token) } }

    it 'should return auth token when confirmed user signs in' do
      expect {
        post '/sign-in', { format: :json, :user => {
          :email => confirmed_user.email,
          :password => confirmed_user.password
        } }
        expect(last_response.status).to be(200)
        expect(last_response.body).to_not be_empty
        expect((body = json(last_response.body)).length).to be(1)

        token = valid_token.call(body[:token])
        expect(token).to_not be_nil
        expect(token).to be_in_use
        expect(token.expires_at).to be_within(3.weeks).of(Time.now)
      }.to change { confirmed_user.reload.authentication_tokens.fresh.count }.by(-1)
        .and change { confirmed_user.reload.authentication_tokens.in_use.count }.by(1)
    end

    it 'should not let unconfirmed users sign in' do
      post '/sign-in', { format: :json, :user => {
        :email => user.email,
        :password => user.password
      } }
      expect(last_response.status).to be(422)
      expect(last_response.body).to_not be_empty
      expect((body = json(last_response.body)).length).to be(1)
      expect(body[:errors]).to include("User's email unconfirmed")
      # Tokens are unused
      user.reload.authentication_tokens.each do |token|
        expect(token).to be_fresh
      end
    end

  end

end
