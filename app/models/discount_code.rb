class DiscountCode < ActiveRecord::Base

  include AASM

  before_save :generate_code, if: -> { new_record? }

  belongs_to :billing_record

  validates :percentage, presence: true
  validates :percentage, numericality: { more_than: 0, less_than_or_equal_to: 100, integer: true }

  # State definitions
  enum state: {
    generated: 1,
    unused: 3,
    used: 5,
    deactivated: 10
  }

  aasm :column => :state do
    state :generated, :initial => true
    state :unused
    state :used
    state :deactivated

    event :assign do
      transitions :from => :generated, :to => :unused
    end

    event :use do
      transitions :from => :unused, :to => :used,
      guards: :validate_billing_record
    end

    event :deactivate do
      transitions :from => [ :generated, :unused ], :to => :deactivated
    end
  end

  private

  def generate_code
    unique = false
    code = self.code || SecureRandom.hex
    while !unique
      if DiscountCode.exists?(code: code)
        code = SecureRandom.hex
      else
        unique = true
      end
    end
    self.code = code
  end

  def validate_billing_record
    billing_record
  end

end
