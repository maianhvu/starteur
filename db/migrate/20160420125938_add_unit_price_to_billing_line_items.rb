class AddUnitPriceToBillingLineItems < ActiveRecord::Migration
  def change
    add_column :billing_line_items, :unit_price, :float, default: 0.0
  end
end
