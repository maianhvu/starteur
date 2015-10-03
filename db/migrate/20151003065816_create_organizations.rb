class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :description
      t.text :street_address

      t.timestamps null: false
    end
  end
end
