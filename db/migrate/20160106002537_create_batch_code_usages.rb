class CreateBatchCodeUsages < ActiveRecord::Migration
  def change
    create_table :batch_code_usages do |t|
      t.references :batch
      t.references :code_usage
      t.boolean :own, default: false
    end
  end
end
