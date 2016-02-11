class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  belongs_to :test
  belongs_to :result

  # Validations
  validates_uniqueness_of :question_id, scope: :user_id
  validates_presence_of :question, :user, :test, :value
end
