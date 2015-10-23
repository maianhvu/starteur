class CreatePromotionCodes < ActiveRecord::Migration
  def change
    create_table :promotion_codes do |t|
      t.integer :billing_record_id
      t.string :code
      t.integer :state
      t.integer :test_id
      t.integer :access_code_id

      t.timestamps null: false
    end
  end
end
