class Question < ActiveRecord::Base
  belongs_to :category
  has_many :choices

  # Validations
  validates :ordinal, numericality: { only_integer: true, allow_blank: true }

  # Scopes
  scope :shuffled, -> { order('random()') }
  scope :ranked, -> { includes(:category).order('categories.rank ASC') }
end
