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

end
