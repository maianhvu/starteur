class Organization < ActiveRecord::Base
  has_many :batches
  # has_many :administrators
end
