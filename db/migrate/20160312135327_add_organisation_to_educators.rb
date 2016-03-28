class AddOrganisationToEducators < ActiveRecord::Migration
  def change
    add_column :educators, :organisation, :string
  end
end
