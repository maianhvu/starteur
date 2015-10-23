class RemoveOrganizationModel < ActiveRecord::Migration
  def change
    drop_table :organizations
  end
end
