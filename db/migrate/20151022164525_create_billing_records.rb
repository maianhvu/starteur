class CreateBillingRecords < ActiveRecord::Migration
  def change
    create_table :billing_records do |t|
      t.string :bill_number
      t.integer :billable_id
      t.string :billable_type

      t.timestamps null: false
    end
  end
end
