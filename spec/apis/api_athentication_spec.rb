require 'rails_helper'

describe "API Authentication", :type => :api do

  let(:user_params) { FactoryGirl.attributes_for(:user) }

  context "Registration" do

    it "should successfully register new user with valid params" do
      post "/register", { :user => user_params }.to_json, {
        "Accept" => Mime::JSON,
        "Content-Type" => Mime::JSON.to_s
      }
      expect(response.status).to be(200)
    end

  end

end
