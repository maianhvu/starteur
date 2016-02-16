class AddPercentageToDiscountCodes < ActiveRecord::Migration
  def change
    add_column :discount_codes, :percentage, :integer
  end
end
