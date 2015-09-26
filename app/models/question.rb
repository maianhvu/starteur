class Question < ActiveRecord::Base
  belongs_to :test

  # Validations
  validates :ordinal, uniqueness: true, numericality: { only_integer: true }
end
