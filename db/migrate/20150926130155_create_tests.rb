class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :name
      t.text :description
      t.string :state
      t.float :price

      t.timestamps null: false
    end
  end
end
