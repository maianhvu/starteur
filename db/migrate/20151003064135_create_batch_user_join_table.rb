class CreateBatchUserJoinTable < ActiveRecord::Migration
  def change
    create_table :batch_user do |t|
      t.references :batch, index: true, null: false
      t.references :user, index: true, null: false
    end
    add_foreign_key :batch_user, :batches
    add_foreign_key :batch_user, :users
  end
end
