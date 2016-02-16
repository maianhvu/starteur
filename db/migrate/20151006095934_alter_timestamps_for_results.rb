class AlterTimestampsForResults < ActiveRecord::Migration
  def change
    change_column :results, :created_at, :datetime, :null => false
    change_column :results, :updated_at, :datetime, :null => false
  end
end
