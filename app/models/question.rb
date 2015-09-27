class Question < ActiveRecord::Base
  belongs_to :category
  has_many :choices

  # Validations
  validates :ordinal, uniqueness: true, numericality: { only_integer: true }

  # Scopes
  scope :shuffled, -> { order('random()') }
end
