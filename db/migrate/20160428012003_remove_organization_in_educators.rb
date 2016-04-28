class RemoveOrganizationInEducators < ActiveRecord::Migration
  def change
    remove_column :educators, :organization
  end
end
