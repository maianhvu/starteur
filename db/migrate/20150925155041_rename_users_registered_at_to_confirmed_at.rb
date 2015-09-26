class RenameUsersRegisteredAtToConfirmedAt < ActiveRecord::Migration
  def change
    rename_column :users, :registered_at, :confirmed_at
  end
end
