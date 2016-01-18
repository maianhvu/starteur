class BatchCodeUsage < ActiveRecord::Base
  belongs_to :batch
  belongs_to :code_usage

  validates :batch, presence: true
  validates :code_usage, presence: true
end
