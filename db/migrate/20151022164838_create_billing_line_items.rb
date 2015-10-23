class CreateBillingLineItems < ActiveRecord::Migration
  def change
    create_table :billing_line_items do |t|
      t.integer :test_id
      t.integer :billing_record_id
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
