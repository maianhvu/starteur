require 'rails_helper'

RSpec.feature 'Dashboard: Test Tasks', type: :feature do

  let!(:user) { FactoryGirl.create(:user, :confirmed) }

  before(:each) do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(current_path).to eq(dashboard_index_path)
  end

  scenario 'User enters access code' do
    visit dashboard_index_path
    click_link 'Enter Access Code'
    # Fill in access code
  end
end
