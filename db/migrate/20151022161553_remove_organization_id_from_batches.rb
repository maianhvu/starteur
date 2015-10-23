class RemoveOrganizationIdFromBatches < ActiveRecord::Migration
  def change
    remove_column :batches, :organization_id
  end
end
