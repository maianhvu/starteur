class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :register_token, :string
    add_column :users, :registered_at, :datetime
    add_column :users, :deactivated, :boolean
  end
end
