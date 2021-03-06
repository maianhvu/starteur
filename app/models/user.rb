class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  include AASM
  include SQLHelper

  # ActiveRecord Relations
  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy
  has_many :scores, dependent: :destroy

  has_many :access_codes, through: :code_usages
  has_many :code_usages, dependent: :destroy

  has_many :billing_records, as: :billable

  # Callbacks
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

    event :confirm_email do
      transitions :from => :registered, :to => :confirmed
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

  # Convenience methods
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  private

  def normalize_email
    self.email = self.email.strip.downcase if self.email
  end

  def capitalize_names
    self.first_name = self.first_name.strip.titleize if self.first_name
    self.last_name = self.last_name.strip.titleize if self.last_name
  end
end
