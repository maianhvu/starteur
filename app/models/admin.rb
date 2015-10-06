class Admin < ActiveRecord::Base
  authenticates_with_sorcery!

  belongs_to :organization
  has_many :access_codes

  validates :email, presence: true, uniqueness: true
  validates :crypted_password, presence: true, on: :create
end
