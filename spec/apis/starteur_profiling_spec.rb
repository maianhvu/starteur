require 'rails_helper'

describe 'API Query Interface', :type => :api do
  let!(:user) {
    u = FactoryGirl.create(:user)
    u.confirm!(u.confirmation_token)
    u
  }

  let!(:test) { FactoryGirl.create(:test) }
  let!(:access_code) { FactoryGirl.create(:access_code, test: test, universal: true) }
  let!(:usage) {
    CodeUsage.new(user: user, access_code: access_code)
  }

  it "should correctly display results" do
    byebug
  end
end
