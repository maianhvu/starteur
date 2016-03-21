class AuditEvent < ActiveRecord::Base
  belongs_to :admin, class_name: 'Educator', foreign_key: 'admin_id'
  belongs_to :other, class_name: 'Educator', foreign_key: 'other_id'

  validates :action, presence: true
  validates :admin, presence: true

  enum action: [:generate_discount_code, :generate_promotion_code, :generate_access_code, :transfer_access_code]

end
