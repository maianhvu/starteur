class AddEmailToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :email, :string, array: true, default: []
  end
end
