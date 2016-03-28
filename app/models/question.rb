class Question < ActiveRecord::Base
  belongs_to :test
  belongs_to :category
  has_many :answers

  # Validations
  validates :ordinal, numericality: { only_integer: true, allow_blank: true }

  # Scopes
  scope :shuffled, -> { order('random()') }
  scope :ranked, -> { includes(:category).order('categories.rank ASC') }
end
