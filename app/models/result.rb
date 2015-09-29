class Result < ActiveRecord::Base

  # ActiveRecord Associations
  belongs_to :test
  belongs_to :user
  belongs_to :code_usage

  # Validations
  validates_presence_of :answers, :test, :user, :code_usage
end
