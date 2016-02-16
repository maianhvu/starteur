class Category < ActiveRecord::Base
  # ActiveRecord Associations
  belongs_to :test
  has_many :questions
  has_many :scores

  scope :ranked, -> { order(:rank => :asc) }
end
