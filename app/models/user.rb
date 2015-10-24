class User < ActiveRecord::Base
  has_secure_password
  include AASM

  # ActiveRecord Relations
  has_many :authentication_tokens, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy
  has_many :code_usages
  has_many :access_codes, through: :code_usages
  has_many :billing_records, as: :billable

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

  def purchased?(test)
    self.code_usages.includes(:access_code).where('access_codes.test_id' => test.id).count > 0
  end

  def completed?(test)
    answers_count = Answer.where(user: self, test: test).count
    (answers_count >= test.questions.count) || (answers_count == 0 && Result.where(user: self, test: test).count > 0)
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
