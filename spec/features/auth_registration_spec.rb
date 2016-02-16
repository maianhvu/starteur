require 'rails_helper'

feature 'Authentication: Registration', type: :feature do

  let!(:user) { FactoryGirl.build_stubbed(:user) }

  context 'Registering from landing page' do

    before(:each) do
      visit root_path
    end

    scenario 'using the form on top with valid credentials' do
      fill_in_register_form '#splash-signup'
      check_last_created_user_and_mail
      expect(current_path).to eq(registration_successful_path)
      expect_signing_in_to_fail
    end

    scenario 'using the form below with valid credentials' do
      fill_in_register_form '#footer-signup'
      check_last_created_user_and_mail
      expect(current_path).to eq(registration_successful_path)
      expect_signing_in_to_fail
    end

  end

  context 'Registering from default registration page' do

    before(:each) do
      visit new_user_registration_path
    end

    scenario 'with valid credentials' do
      fill_in_register_form '#new_user'
      check_last_created_user_and_mail
      expect(current_path).to eq(registration_successful_path)
    end

  end

  private

  def fill_in_register_form(form_id)
    expect {
      within(form_id) do
        fill_in 'First name', with: user.first_name
        fill_in 'Last name', with: user.last_name
        fill_in 'Email', with: user.email
        fill_in :user_password, with: user.password
        click_button 'Register'
      end
    }.to change { User.count }.by(1)
      .and change { ActionMailer::Base.deliveries.count }.by(1)
  end

  def check_last_created_user_and_mail
    # Check last created user
    user = User.last
    expect(user).to be_registered

    # Check last sent email
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to contain_exactly(user.email)
  end

  def try_signing_in
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end

  def expect_signing_in_to_fail
    try_signing_in
    expect(current_path).to_not eq(dashboard_index_path)
    expect(current_path).to eq(new_user_session_path)
  end

end
