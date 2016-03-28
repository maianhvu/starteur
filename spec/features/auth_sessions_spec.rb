require 'rails_helper'

feature 'Authentication: Sessions', type: :feature do

  let!(:confirmed_user) { FactoryGirl.create(:user, :confirmed) }

  context 'Signing in from landing page' do
    before(:each) do
      visit root_path
    end

    scenario 'with valid credentials' do
      within('#header-wrapper') do
        click_link 'Sign in here'
      end
      fill_in_sign_in_form '#sign-in-form'
      expect(current_path).to eq(dashboard_index_path)
    end

  end

  context 'Signing in from default sign in page' do
    before(:each) do
      visit new_user_session_path
    end

    scenario 'with valid credentials' do
      fill_in_sign_in_form '#new_user'
      expect(current_path).to eq(dashboard_index_path)
    end
  end

  private

  def fill_in_sign_in_form(form_id)
    within(form_id) do
      fill_in 'Email', with: confirmed_user.email
      fill_in 'Password', with: confirmed_user.password
      click_button 'Sign in'
    end
  end
end
