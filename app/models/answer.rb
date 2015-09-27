class Answer < ActiveRecord::Base
  belongs_to :choice
  belongs_to :user
  belongs_to :test

  # Validations
  validate :is_unique_to_same_user_and_question, on: :create
  validates_presence_of :choice_id, :user_id, :test_id

  private

  def is_unique_to_same_user_and_question
    return unless self.choice && self.user
    choice_ids = self.choice.question.choices.map(&:id)
    if self.user.answers.where('choice_id IN (?)', choice_ids).count > 0
      errors.add(:answer, "must be unique to a user in a question")
    end
  end
end
