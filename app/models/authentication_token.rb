class AuthenticationToken < ActiveRecord::Base
  belongs_to :user
  include AASM

  # Constants
  DEFAULT_EXPIRY = Proc.new { 3.weeks.from_now }

  # Validations
  validates_presence_of :user

  # State definitions
  aasm :column => :state do
    state :fresh, :initial => true, :after_enter => :generate_token
    state :in_use
    state :expired

    event :use do
      transitions :from => [ :fresh, :in_use ], to: :expired, if: :token_expired?
      transitions :from => [ :fresh, :in_use ], to: :in_use, after: :extend_expiration
    end

    event :expire do
      transitions :from => [ :fresh, :in_use ], to: :expired
    end

    event :refresh do
      transitions :from => [ :expired ], to: :fresh
    end
  end

  private

  def token_expired?
    Time.now >= self.expires_at
  end

  def extend_expiration
    self.expires_at = DEFAULT_EXPIRY.call
  end

  def generate_token
    while true
      t = SecureRandom.hex(32)
      break t unless self.user && self.user.authentication_tokens.find_by(token: t)
    end
    self.token = t
    self.expires_at = DEFAULT_EXPIRY.call
  end
end
