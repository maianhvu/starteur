class Result < ActiveRecord::Base

  # ActiveRecord Associations
  belongs_to :test
  belongs_to :user

  # Validations
  validates_presence_of :answers, :test, :user
end
