class AddTestIdToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :test_id, :integer
  end
end
