class BillingRecord < ActiveRecord::Base
  belongs_to :billable, polymorphic: true, inverse_of: :billing_records
  has_many :billing_line_items
  has_one :discount_code
  # has_one :promotion_code
end
