class AccessCode < ActiveRecord::Base
  belongs_to :test
  belongs_to :educator
  has_many :code_usages, dependent: :destroy
  has_many :users, through: :code_usages

  def user
    return nil if self.universal
    self.users.first
  end

end
