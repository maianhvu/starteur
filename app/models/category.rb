class Category < ActiveRecord::Base
  # ActiveRecord Associations
  belongs_to :test
  has_many :questions, dependent: :destroy

  scope :ranked, -> { order(:rank => :asc) }
end
