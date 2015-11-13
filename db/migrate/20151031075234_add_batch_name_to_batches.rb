class AddBatchNameToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :name, :string
  end
end
