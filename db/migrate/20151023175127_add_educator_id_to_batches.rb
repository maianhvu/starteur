class AddEducatorIdToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :educator_id, :integer
  end
end
