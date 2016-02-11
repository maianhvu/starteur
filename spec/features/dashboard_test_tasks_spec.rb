require 'rails_helper'

RSpec.feature 'Dashboard: Test Tasks', type: :feature do

  let!(:user) { FactoryGirl.create(:user, :confirmed) }
  let!(:test) { FactoryGirl.create(:test) }
  let!(:access_code) { FactoryGirl.create(:access_code, test: test) }

  before(:each) do
    sign_in_using(user)
    expect(current_path).to eq(dashboard_index_path)
  end

  scenario 'User enters access code' do
    visit dashboard_index_path
    # Fill in access code
    expect { fill_in_and_submit_code }
      .to change { CodeUsage.count }.by(1)
      .and change { access_code.reload.code_usages_count }.by(1)

    # Validate the newly created Code Usage
    usage = CodeUsage.last
    expect(usage.user.id).to be(user.id)
    expect(usage.access_code).to eq(access_code)
    expect(usage).to be_used
    expect(usage.user_id).to eq(user.id)

    # Expect a redirection to the test begin page
    expect(current_path).to eq(begin_test_path(test.id))
  end

  scenario 'User should see only the take test button if already entered code' do
    visit dashboard_index_path
    fill_in_and_submit_code
    visit dashboard_index_path
    expect(page).to have_link 'Take the Test'
    expect(page).to_not have_link 'Enter Access Code'
    expect(page).to_not have_css '.button', text: 'Purchase'
  end

  private

  def fill_in_and_submit_code
    click_link 'Enter Access Code'
    within('#access-code') do
      fill_in 'Access Code', with: access_code.code
      click_button 'Submit'
    end
  end
end
