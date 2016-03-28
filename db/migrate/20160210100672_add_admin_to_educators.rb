class AddAdminToEducators < ActiveRecord::Migration
  def change
    add_column :educators, :admin, :boolean, default: false
  end
end
