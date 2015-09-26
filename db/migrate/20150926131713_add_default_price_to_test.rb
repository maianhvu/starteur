class AddDefaultPriceToTest < ActiveRecord::Migration
  def change
    change_column :tests, :price, :float, :default => 0.0

    Test.where(price: nil).each do |t|
      t.update_attributes(price: 0.0)
      t.save!
    end
  end
end
