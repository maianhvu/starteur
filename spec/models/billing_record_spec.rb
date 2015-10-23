require 'rails_helper'

RSpec.describe BillingRecord, type: :model do

  it { is_expected.to belong_to(:billable) }
  it { is_expected.to have_many(:billing_line_items) }
  it { is_expected.to have_one(:discount_code) }
  it { is_expected.to have_one(:promotion_code) }

  it { is_expected.to validate_presence_of(:billable) }

end
