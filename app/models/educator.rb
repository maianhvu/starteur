class Educator < ActiveRecord::Base
  # authenticates_with_sorcery!
  include AASM

  has_many :access_codes
  has_many :batches
  has_many :billing_records

  validates :email, presence: true, uniqueness: true
  validates :crypted_password, presence: true, on: :create

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
end
