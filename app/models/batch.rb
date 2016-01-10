class Batch < ActiveRecord::Base
  belongs_to :educator
  has_many :code_usages
  has_and_belongs_to_many :results
  belongs_to :test

  validates :educator, presence: true
  validates :test, presence: true
  validates :name, presence: true
end
