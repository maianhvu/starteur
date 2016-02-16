class AddCodeUsageCounterCacheToAccessCodes < ActiveRecord::Migration
  def change
    add_column :access_codes, :code_usages_count, :integer, null: false, default: 0
  end
end
