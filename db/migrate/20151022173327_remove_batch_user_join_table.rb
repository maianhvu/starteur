class RemoveBatchUserJoinTable < ActiveRecord::Migration
  def change
    remove_foreign_key :batch_user, :batches
    remove_foreign_key :batch_user, :users
    drop_table :batch_user
  end
end
