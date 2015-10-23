class DiscountCode < ActiveRecord::Base

  include AASM

  belongs_to :billing_record

  # State definitions
  enum state: {
    unused: 1,
    used: 5,
    deactivated: 10
  }

  aasm :column => :state do
    state :unused, :initial => true
    state :used
    state :deactivated

    event :use do
      transitions :from => :unused, :to => :used
    end

    event :deactivate do
      transitions :from => [ :unused, :used ], :to => :deactivated
    end
  end

end
