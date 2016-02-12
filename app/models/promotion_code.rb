class PromotionCode < ActiveRecord::Base

  before_save :generate_code

  belongs_to :billing_record
  belongs_to :access_code
  belongs_to :test

  validates :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  private

  def generate_code
    unique = false
    code = SecureRandom.hex
    while !unique
      if DiscountCode.find_by(code: code)
        code = SecureRandom.hex
      else
        unique = true
      end
    end
    self.code = code
  end

end
