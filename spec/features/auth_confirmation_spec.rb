require 'rails_helper'

feature 'Authentication: Confirmation', type: :feature do

  scenario 'Confirming from email' do
    # Try to register for a new account first
    user = FactoryGirl.build_stubbed(:user)
    user_password = user.password

    expect {
      visit new_user_registration_path
      fill_in 'First name', with: user.first_name
      fill_in 'Last name', with: user.last_name
      fill_in 'Email', with: user.email
      fill_in :user_password, with: user_password
      click_button 'Register'
    }.to change { User.count }.by(1)

    # Get last created user
    user = User.last
    # Confirm integrity
    expect(user.email).to eq(ActionMailer::Base.deliveries.last.to.first)
    expect(user).to be_registered
    expect(user).to_not be_confirmed
    expect(user.confirmed_at).to be_nil

    # Get last email
    open_email(user.email)

    # Follow link
    expect {
      current_email.click_link 'Confirm my account'
    }.to change { user.reload.state }.from('registered').to('confirmed')
    expect(user.confirmed_at).to be_within(5.seconds).of(Time.now)

    # Should log in again, and succeed
    expect(current_path).to eq(new_user_session_path)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user_password
    click_button 'Sign in'

    expect(current_path).to eq(dashboard_index_path)
  end
end
