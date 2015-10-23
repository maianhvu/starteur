class CreateBatchesResultsJoinTable < ActiveRecord::Migration
  def change
    create_table :batches_results, id: false do |t|
      t.references :batch, index: true, foreign_key: true
      t.references :result, index: true, foreign_key: true
    end
  end
end
