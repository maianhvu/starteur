class User < ActiveRecord::Base
  has_secure_password
  include AASM

  # Callbacks
  before_validation :normalize_email, on: :create

  # Validations
  validates :email, presence: true
  validates_presence_of :first_name, :last_name

  # State definitions
  aasm :column => :state do
    state :registered, :initial => true,
      before_enter: [ :create_confirmation_token ]
    state :confirmed
    state :deactivated

    event :confirm do
      transitions :from => :registered, :to => :confirmed,
        :guards => :validate_confirmation_token,
        :after  => :set_confirmed_date
    end

    event :deactivate do
      transitions :from => [ :registered, :confirmed ], :to => :deactivated
    end
  end

  private

  def normalize_email
    self.email = self.email.strip.downcase
  end

  def create_confirmation_token
    self.confirmation_token = SecureRandom.hex(32)
  end

  def validate_confirmation_token(token)
    self.confirmation_token == token
  end

  def set_confirmed_date
    self.confirmed_at = Time.now
    self.save!
  end
end
