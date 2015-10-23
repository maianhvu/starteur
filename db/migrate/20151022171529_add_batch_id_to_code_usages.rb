class AddBatchIdToCodeUsages < ActiveRecord::Migration
  def change
    add_column :code_usages, :batch_id, :integer
  end
end
