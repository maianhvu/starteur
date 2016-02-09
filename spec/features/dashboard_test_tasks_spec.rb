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
    click_link 'Enter Access Code'
    # Fill in access code
    expect {
      within('#access-code') do
        fill_in 'Access Code', with: access_code.code
        click_button 'Submit'
      end
    }.to change { CodeUsage.count }.by(1)

    # Validate the newly created Code Usage
    usage = CodeUsage.last
    expect(usage.user.id).to be(user.id)
    expect(usage.access_code).to eq(access_code)

    # Expect a redirection to the test begin page
    expect(current_path).to eq(begin_test_path(test.id))
  end
end
