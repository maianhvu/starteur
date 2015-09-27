class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.integer :rank
      t.string :title
      t.text :description
      t.references :test, index: true, foreign_key: true

      t.timestamps null: false
    end

    # Add references
    add_reference :questions, :category, index: true, foreign_key: true
    remove_reference :questions, :test
  end

  def down
    drop_table :categories
    remove_reference :questions, :category
  end
end
