require 'rails_helper'

RSpec.feature 'Test Taking', type: :feature do

  given(:user) { FactoryGirl.create(:user, :confirmed) }
  given(:test) { FactoryGirl.create(:test, :full) }
  given(:access_code) { FactoryGirl.create(:access_code, test: test) }
  given(:code_usage) {
    CodeUsage.create!(
      user: user,
      test: test,
      access_code: access_code,
      state: CodeUsage.states[:used]
    )
  }

  scenario 'User takes a full test from start to end' do
    Capybara.current_driver = :selenium
    sign_in_using(user)
    visit take_test_path(test.id)
  end

end
