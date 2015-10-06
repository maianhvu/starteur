class Organization < ActiveRecord::Base
  has_many :batches
  has_many :admins
end
