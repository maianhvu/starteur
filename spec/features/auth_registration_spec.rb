require 'rails_helper'

feature "Authentication: Registration", type: :feature do

  context 'Registering from landing page' do

    before(:each) do
      visit root_path
    end

    scenario 'using the form on top' do
      fill_in_register_form '#splash-signup'
      check_last_created_user_and_mail
    end

  end

  private

  def fill_in_register_form(form_id)
    expect {
      within(form_id) do
        fill_in 'First name', with: 'Anh Vu'
        fill_in 'Last name', with: 'Mai'
        fill_in 'Email', with: 'me@maianhvu.com'
        fill_in 'Password', with: 'secretpassword'
        check :agreetoterms
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
