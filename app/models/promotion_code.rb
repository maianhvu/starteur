class PromotionCode < ActiveRecord::Base

  include AASM

  before_save :generate_code, if: -> { new_record? }

  belongs_to :billing_record
  belongs_to :access_code
  belongs_to :test

  validates :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0 }

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
      guards: :validate_access_code
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
      if PromotionCode.exists?(code: code)
        code = SecureRandom.hex
      else
        unique = true
      end
    end
    self.code = code
  end

  def validate_access_code
    access_code
  end

end
