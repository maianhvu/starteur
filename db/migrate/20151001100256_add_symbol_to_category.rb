class AddSymbolToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :symbol, :string
  end
end
