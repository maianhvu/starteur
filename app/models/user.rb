class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true
  validates_presence_of :first_name, :last_name
end
