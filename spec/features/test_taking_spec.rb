require 'rails_helper'

RSpec.feature 'Test Taking', type: :feature do

  given(:user) { FactoryGirl.create(:user, :confirmed) }
  given(:test) { FactoryGirl.create(:test) }

  before(:each) do
    sign_in_using(user)
  end

  scenario 'User has not signed in' do
    sign_out
    visit begin_test_path(test.id)
    expect(current_path).to eq(new_user_session_path)
  end

  context 'Without code usage' do

    scenario 'User is prevented from take test' do
      # Generate bait code (unused)
      FactoryGirl.create(:access_code, test: test)
      visit begin_test_path(test.id)
      # Redirects away
      expect(current_path).to eq(dashboard_index_path)
      # TODO: Check for error messages
    end

  end

  context 'With code usage' do
    given(:access_code) { FactoryGirl.create(:access_code, test: test) }

    before(:each) do
      CodeUsage.create!(
        user: user,
        access_code: access_code,
        test: test,
        state: CodeUsage.states[:used]
      )
    end

    scenario 'User is allowed to take test' do
      path = begin_test_path(test.id)
      visit path
      expect(current_path).to eq(path)
    end

    scenario 'User can read instructions and then start test' do
      path = begin_test_path(test.id)
      visit path
      expect(current_path).to eq(path)
      # Verify element
      expect(page).to have_css 'h1', text: test.name
      click_link 'Ready to go!'
      expect(current_path).to eq(take_test_path(test.id))
    end

  end
end
