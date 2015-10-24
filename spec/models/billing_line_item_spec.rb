require 'rails_helper'

RSpec.describe BillingLineItem, type: :model do

  it { is_expected.to belong_to(:test) }
  it { is_expected.to belong_to(:billing_record) }

  it { is_expected.to validate_presence_of(:test) }
  it { is_expected.to validate_presence_of(:billing_record) }
  it { is_expected.to validate_presence_of(:quantity) }

end
