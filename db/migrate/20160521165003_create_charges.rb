class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.integer :amount
      t.integer :coupon_id
      t.integer :stripe_id

      t.timestamps null: false
    end
  end
end
