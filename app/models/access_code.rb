class AccessCode < ActiveRecord::Base
  belongs_to :test
  has_many :code_usages
  has_many :users, through: :code_usages

  def user
    return nil if self.universal
    self.users.first
  end

end
