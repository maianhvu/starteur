class Batch < ActiveRecord::Base
  has_one :educator
  has_many :code_usages
  belongs_to :test

  validates :educator, presence: true
  validates :test, presence: true
end
