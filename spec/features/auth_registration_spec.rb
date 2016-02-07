require 'rails_helper'

feature "Authentication: Registration", type: :feature do

  context 'Registering from landing page' do

    before(:each) do
      visit root_path
    end

    scenario 'using the form on top with valid credentials' do
      fill_in_register_form '#splash-signup'
      check_last_created_user_and_mail
      expect(current_path).to eq(registration_successful_path)
    end

    scenario 'using the form below with valid credentials' do
      fill_in_register_form '#footer-signup'
      check_last_created_user_and_mail
      expect(current_path).to eq(registration_successful_path)
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
        fill_in 'First name', with: 'Anh Vu'
        fill_in 'Last name', with: 'Mai'
        fill_in 'Email', with: 'me@maianhvu.com'
        fill_in :user_password, with: 'secretpassword'
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
    expect(mail.to).to contain_exactly('me@maianhvu.com')
  end

end
