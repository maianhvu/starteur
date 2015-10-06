class RenameAdministratorModelToAdmin < ActiveRecord::Migration
  def change
    rename_table :administrators, :admins
  end
end
