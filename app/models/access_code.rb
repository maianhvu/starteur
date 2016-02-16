class AccessCode < ActiveRecord::Base

  include ActiveRecord::CounterCache

  before_save :generate_code, if: -> { new_record? }

  belongs_to :test
  belongs_to :educator
  has_many :code_usages, dependent: :destroy
  has_many :users, through: :code_usages
  has_one :promotion_code

  after_create :set_code_usages_counter

  def user
    return nil if self.universal?
    self.users.first
  end

  def universal?
    self.permits < 0
  end

  private

  def set_code_usages_counter
    AccessCode.reset_counters(self.id, :code_usages)
  end

  def generate_code
    unless code
      unique = false
      code = self.code || SecureRandom.hex
      while !unique
        if AccessCode.exists?(code: code)
          code = SecureRandom.hex
        else
          unique = true
        end
      end
      self.code = code
    end
  end

end
