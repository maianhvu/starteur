class DiscountCode < ActiveRecord::Base

  include AASM

  before_save :generate_code

  belongs_to :billing_record

  validates :percentage, presence: true
  validates :percentage, numericality: { more_than_or_equal_to: 0, integer: true }

  # State definitions
  enum state: {
    unused: 1,
    used: 5,
    deactivated: 10
  }

  aasm :column => :state do
    state :unused, :initial => true
    state :used
    state :deactivated

    event :use do
      transitions :from => :unused, :to => :used
    end

    event :deactivate do
      transitions :from => [ :unused, :used ], :to => :deactivated
    end
  end

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
