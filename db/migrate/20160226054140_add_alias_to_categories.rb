class AddAliasToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :alias, :string

    Category.all.each do |category|
      category.alias = category.title.gsub(/(\s+|-+)/, "_").downcase
      category.save!
    end

    add_index :categories, [:test_id, :alias], :unique => true
  end
end
