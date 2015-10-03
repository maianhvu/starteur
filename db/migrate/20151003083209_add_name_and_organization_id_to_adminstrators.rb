class AddNameAndOrganizationIdToAdminstrators < ActiveRecord::Migration
  def change
    add_column :administrators, :organization_id, :integer
    add_column :administrators, :name, :string
  end
end
