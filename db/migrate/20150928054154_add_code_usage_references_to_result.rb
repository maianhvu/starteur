class AddCodeUsageReferencesToResult < ActiveRecord::Migration
  def change
    add_reference :results, :code_usage, index: true, foreign_key: true
  end
end
