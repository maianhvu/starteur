require 'rails_helper'

RSpec.feature 'Test Taking', type: :feature do

  let!(:user) { FactoryGirl.create(:user, :confirmed) }
  let!(:test) { FactoryGirl.create(:test) }
  let!(:access_code) { FactoryGirl.create(:access_code, test: test) }

  before(:each) do
    sign_in_using(user)
  end

  context 'Without code usage' do

    scenario 'User is prevented from take test' do
      visit begin_test_path(test.id)
      # Redirects away
      expect(current_path).to eq(dashboard_index_path)
      # TODO: Check for error messages
    end

  end

  context 'With code usage' do
    let!(:code_usage) { CodeUsage.create!(user: user, access_code: access_code) }

    scenario 'User is allowed to take test' do
      path = begin_test_path(test.id)
      visit path
      expect(current_path).to eq(path)
    end
  end
end
