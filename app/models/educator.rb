class Educator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # authenticates_with_sorcery!
  include AASM

  has_many :access_codes
  has_many :batches
  has_many :billing_records, as: :billable
  has_and_belongs_to_many :cobatches, class_name: 'Batch', join_table: 'batches_coeducators'

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }

  # State definitions
  enum state: {
    registered: 1,
    activated: 5,
    deactivated: 10
  }

  aasm :column => :state do
    state :registered, :initial => true
    state :activated
    state :deactivated

    event :activate do
      transitions :from => :registered, :to => :activated
    end

    event :deactivate do
      transitions :from => [ :registered, :activated ], :to => :deactivated
    end
  end

  def name
    if last_name && first_name
      "#{last_name} #{first_name}"
    else
      last_name || first_name || 'Educator'
    end
  end

end
