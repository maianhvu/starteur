class Test < ActiveRecord::Base
  include AASM

  # ActiveRecord Associations
  has_many :categories
  has_many :questions, through: :categories
  has_many :answers
  has_many :results

  # Validations
  validates :name, presence: true, uniqueness: true

  # Callbacks
  before_save :set_defaults

  # State definitions
  enum state: {
    unpublished: 1,
    published: 2,
    deleted: 4
  }

  aasm :column => :state, :enum => true do
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
