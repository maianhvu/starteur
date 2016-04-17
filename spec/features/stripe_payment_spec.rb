require 'rails_helper'

RSpec.feature 'Stripe Payment', type: :feature do

  let!(:user) { FactoryGirl.create(:user, :confirmed) }
  let!(:test) { FactoryGirl.create(:test) }

  before(:each) do
    sign_in_using(user)
    expect(current_path).to eq(dashboard_index_path)
    sleep(5)
  end


  scenario 'User purchases test', :js => true do
    expect { fill_in_and_purchase_test }
    .to change { AccessCode.count }.by(1)

    expect(current_path).to eq(charges_path)

  end

  def fill_in_and_purchase_test
    click_button 'Purchase'
    sleep(5)
    stripe_iframe = all('iframe[name=stripe_checkout_app]').last

    Capybara.within_frame stripe_iframe do
      fill_in 'Email', with: user.email
      fill_in 'Card number', with: '4242424242424242'
      fill_in 'MM / YY', with: '12/34'
      fill_in 'CVC', with: '424'
      click_button 'Pay US$10.00'
      sleep(10)
    end
  end

end
