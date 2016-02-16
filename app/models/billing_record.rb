class BillingRecord < ActiveRecord::Base
  belongs_to :billable, polymorphic: true
  has_many :billing_line_items
  has_one :discount_code
  has_one :promotion_code

  validates :billable, presence: true

  def calculate_value
    subtotal = billing_line_items.inject(0) { |a, e| a + e.calculate_value }
    if discount_code
      subtotal *= (100 - discount_code.percentage) / 100
    end
    subtotal
  end

end
