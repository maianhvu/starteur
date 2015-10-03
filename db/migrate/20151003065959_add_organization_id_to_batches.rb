class AddOrganizationIdToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :organization_id, :integer
  end
end
