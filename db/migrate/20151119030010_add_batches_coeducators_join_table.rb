class AddBatchesCoeducatorsJoinTable < ActiveRecord::Migration
  def change
    create_table :batches_coeducators, id: false do |t|
      t.references :batch, index: true, foreign_key: true
      t.references :educator, index: true, foreign_key: true
    end
    add_index :batches_coeducators, [:batch_id, :educator_id], unique: true
  end
end
