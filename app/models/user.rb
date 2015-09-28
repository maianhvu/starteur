class User < ActiveRecord::Base
  has_secure_password
  include AASM

  # ActiveRecord Relations
  has_many :authentication_tokens
  has_many :answers
  has_many :results

  # Callbacks
  before_create :generate_confirmation_token
  before_validation :normalize_email, on: :create
  before_save :capitalize_names

  # Validations
  validates :email, presence: true, uniqueness: true
  validates_presence_of :first_name, :last_name

  # State definitions
  enum state: {
    registered: 1,
    confirmed: 8,
    deactivated: 32
  }
  aasm :column => :state do
    state :registered, :initial => true
    state :confirmed
    state :deactivated

    event :confirm do
      transitions :from => :registered, :to => :confirmed,
        :guards => :validate_confirmation_token,
        :after  => [ :set_confirmed_date, :generate_auth_token ]
    end

    event :deactivate do
      transitions :from => [ :registered, :confirmed ], :to => :deactivated
    end
  end

  private

  def normalize_email
    self.email = self.email.strip.downcase if self.email
  end

  def capitalize_names
    self.first_name = self.first_name.strip.titleize if self.first_name
    self.last_name = self.last_name.strip.titleize if self.last_name
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.hex(32)
  end

  def validate_confirmation_token(token)
    self.confirmation_token == token
  end

  def set_confirmed_date
    self.confirmed_at = Time.now
    self.save!
  end

  def generate_auth_token
    AuthenticationToken.create!(user: self)
  end
end
