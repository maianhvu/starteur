class PromotionCode < ActiveRecord::Base

  belongs_to :billing_record
  belongs_to :access_code
  belongs_to :test

end
