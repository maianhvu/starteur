require 'rails_helper'

RSpec.describe PromotionCode, type: :model do
  
  it { is_expected.to belong_to(:billing_record) }
  it { is_expected.to belong_to(:access_code) }
  it { is_expected.to belong_to(:test) }

end
