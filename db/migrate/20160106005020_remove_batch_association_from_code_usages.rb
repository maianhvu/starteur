class RemoveBatchAssociationFromCodeUsages < ActiveRecord::Migration
  def change
    remove_column :code_usages, :batch_id, :integer
  end
end
