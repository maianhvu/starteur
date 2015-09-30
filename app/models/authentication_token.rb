class AuthenticationToken < ActiveRecord::Base
  belongs_to :user
  include AASM

  # Constants
  DEFAULT_EXPIRY = Proc.new { 3.weeks.from_now }
  TRIAL_EXPIRY = Proc.new { 1.hour.from_now }

  # Validations
  validates_presence_of :user

  # Callbacks
  before_create :generate_token

  # State definitions
  enum state: {
    fresh: 1,
    in_use: 2,
    expired: 4
  }
  aasm :column => :state, :enum => true do
    state :fresh, :initial => true
    state :in_use
    state :expired

    event :use do
      transitions :from => [ :fresh, :in_use ], to: :expired, if: :token_expired?
      transitions :from => [ :fresh, :in_use ], to: :in_use, after: [ :extend_expiration, :update_last_used ]
    end

    event :expire do
      transitions :from => [ :fresh, :in_use ], to: :expired
    end

    event :refresh do
      transitions :from => [ :expired ], to: :fresh, after: :generate_token
    end
  end

  def trial?
    return true unless self.user
    return !self.user.confirmed?
  end

  private

  def token_expired?
    Time.now >= self.expires_at
  end

  def extend_expiration
    return if self.trial?
    self.expires_at = DEFAULT_EXPIRY.call
  end

  def update_last_used
    self.last_used_at = Time.now
  end

  def generate_token
    while true
      t = SecureRandom.hex(32)
      break t unless self.user && self.user.authentication_tokens.find_by(token: t)
    end
    self.token = t
    return self.expires_at = TRIAL_EXPIRY.call if self.trial?
    self.expires_at = DEFAULT_EXPIRY.call
  end
end
