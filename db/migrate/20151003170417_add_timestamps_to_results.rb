class AddTimestampsToResults < ActiveRecord::Migration
  def change
    add_column :results, :created_at, :datetime, null: false
    add_column :results, :updated_at, :datetime, null: false
  end
end
