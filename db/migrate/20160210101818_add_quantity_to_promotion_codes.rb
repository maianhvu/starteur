class AddQuantityToPromotionCodes < ActiveRecord::Migration
  def change
    add_column :promotion_codes, :quantity, :integer
  end
end
