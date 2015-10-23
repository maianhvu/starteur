class CreateDiscountCodes < ActiveRecord::Migration
  def change
    create_table :discount_codes do |t|
      t.integer :billing_record_id
      t.string :code
      t.integer :state

      t.timestamps null: false
    end
  end
end
