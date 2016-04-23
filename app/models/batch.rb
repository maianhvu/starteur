class Batch < ActiveRecord::Base
  belongs_to :educator
  has_and_belongs_to_many :coeducators, class_name: 'Educator', join_table: 'batches_coeducators'
  has_many :batch_code_usages, dependent: :destroy
  has_many :code_usages, through: :batch_code_usages
  has_and_belongs_to_many :results
  belongs_to :test

  validates :educator, presence: true
  validates :test, presence: true
  validates :name, presence: true
end
