class Admin < ActiveRecord::Base
  authenticates_with_sorcery!

  belongs_to :organization
  has_many :access_codes
  has_many :purchase_records

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }

  validates :email, presence: true, uniqueness: true
end
