class RenameUsersRegistrationTokenToConfirmationToken < ActiveRecord::Migration
  def change
    rename_column :users, :register_token, :confirmation_token
  end
end
