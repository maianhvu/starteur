class AddBillingRecordToAccessCode < ActiveRecord::Migration
  def change
    add_reference :access_codes, :billing_record
  end
end
