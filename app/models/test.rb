class Test < ActiveRecord::Base
  has_many :questions
  include AASM

  # Validations
  validates :name, presence: true, uniqueness: true

  # Callbacks
  before_save :set_defaults

  # State definitions
  aasm :column => :state do
    state :unpublished, :initial => true
    state :published
    state :deleted

    event :publish do
      transitions :from => :unpublished, :to => :published
    end

    event :unpublish do
      transitions :from => :published, :to => :unpublished
    end

    event :delete do
      transitions :from => [ :unpublished, :published ], :to => :deleted
    end

    event :recover do
      transitions :from => :deleted, :to => :unpublished
    end
  end

  private

  def set_defaults
    self.price ||= 0.0
  end
end
