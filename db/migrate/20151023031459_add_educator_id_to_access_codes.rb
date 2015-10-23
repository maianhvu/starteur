class AddEducatorIdToAccessCodes < ActiveRecord::Migration
  def change
    add_column :access_codes, :educator_id, :integer
  end
end
