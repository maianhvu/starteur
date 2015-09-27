class Choice < ActiveRecord::Base
  belongs_to :question

  # Validations
  validates :content, presence: true, uniqueness: { scope: :question, case_sensitive: false }
  validates :points, presence: true, numericality: { only_integers: true }
end
