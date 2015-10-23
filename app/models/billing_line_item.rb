class BillingLineItem < ActiveRecord::Base

  belongs_to :test
  belongs_to :billing_record

  validates :test, presence: true
  validates :billing_record, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

end
