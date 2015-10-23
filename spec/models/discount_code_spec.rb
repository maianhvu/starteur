require 'rails_helper'

RSpec.describe DiscountCode, type: :model do
  
  it { is_expected.to belong_to(:billing_record) }

end
