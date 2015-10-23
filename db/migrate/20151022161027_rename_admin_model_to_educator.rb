class RenameAdminModelToEducator < ActiveRecord::Migration
  def change
    rename_table :admins, :educators
  end
end
