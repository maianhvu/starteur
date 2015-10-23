class RemoveOrganizationIdFromEducators < ActiveRecord::Migration
  def change
    remove_column :educators, :organization_id
  end
end
