class AddAdditionalFieldsToEducator < ActiveRecord::Migration
  def change
    rename_column :educators, :name, :first_name
    add_column :educators, :last_name, :string
    add_column :educators, :organization, :string
    add_column :educators, :title, :string
    add_column :educators, :secondary_email, :string
  end
end
