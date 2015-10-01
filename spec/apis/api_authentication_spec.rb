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
        expect(body[:user]).to have_key(:email)
        expect(body[:user][:email]).to_not be_empty
        expect(body[:user]).to have_key(:token)
        expect(body[:user][:token]).to_not be_empty
        expect(body[:user][:token].length).to be(64)
        # Expect token to be trial
        token = AuthenticationToken.find_by(token: body[:user][:token])
        expect(token).to be_trial
        expect(token.may_refresh?).to be_falsy
        expect(token.expires_at).to be_within(1.minute).of(1.hour.from_now)
        # Just to make sure the token belongs to this user
        user = User.find_by(email: user_params[:email])
        expect(token.user).to eq(user)
      }.to change{ User.count }.by(1)
    end

    it 'should fail to register new user with invalid params' do
      expect {
        invalid_user_params.each do |invalid_params|
          post '/register', { format: :json, user: invalid_params }
          expect(last_response.status).to be(422)
          expect(last_response.body).to_not be_empty
          expect((body = json(last_response.body)).length).to be(2)
          expect(body).to have_key(:errorFields)
          invalid_key = invalid_params.select { |k,v| v.nil? }.keys.first.to_s
          expect(body[:errorFields]).to contain_exactly(invalid_key)
        end
      }.not_to change{ User.count }
    end

    it 'should fail to register repeated emails' do
      User.create!(user_params)
      expect {
        post '/register', { format: :json, user: user_params }
        expect(last_response.status).to be(422)
        expect((body = json(last_response.body)).length).to be(2)
        expect(body).to have_key(:errors)
        expect(body[:errors]).to include("Email")
        expect(body).to have_key(:errorFields)
        expect(body[:errorFields]).to contain_exactly('email')
      }.not_to change { User.count }
    end

    it 'should generate a trial auth token upon successful registration' do
      expect {
        post '/register', { format: :json, user: user_params }
      }.to change{ AuthenticationToken.count }.by(1)
      token = User.find_by(email: user_params[:email]).authentication_tokens.last
      expect(token).to be_trial
      expect(token.expires_at).to be_within(1.minute).of(1.hour.from_now)
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
      expect(user.reload).to be_confirmed
      expect(user.confirmed_at).to be_within(10.seconds).of(Time.now)
      expect(last_response.status).to be(200)
      expect(last_response.body).to be_empty
      # Expect all tokens to be non-trial
      user.authentication_tokens.each do |token|
        expect(token).to_not be_trial
      end
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
        expect(body).to have_key(:user)
        user_data = body[:user]

        expect(user_data).to have_key(:email)
        expect(user_data[:email]).to eq(confirmed_user.email)

        token = valid_token.call(user_data[:token])
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
      expect((body = json(last_response.body)).length).to be(2)
      expect(body).to have_key(:errors)
      expect(body[:errors]).to eq('You have not confirmed your email address')
      expect(body).to have_key(:errorFields)
      expect(body[:errorFields]).to be_empty
      # Tokens are unused
      user.reload.authentication_tokens.each do |token|
        expect(token).to be_fresh
      end
    end

    it 'should set token to expired when user signs out' do
      # confirm the user first
      user.confirm!(user.confirmation_token)
      # get the auth token
      token = user.authentication_tokens.first
      token.use!
      # use it to log out
      token_header token.token
      post '/sign-out', { format: :json, :user => {
        :email => user.email
      } }
      expect(last_response.status).to be(200)
      expect(last_response.body).to be_empty
      token.reload
      expect(token).to be_expired
    end

  end

end
