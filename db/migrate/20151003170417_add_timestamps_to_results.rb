class AddTimestampsToResults < ActiveRecord::Migration
  def change
    add_column :results, :created_at, :datetime
    add_column :results, :updated_at, :datetime
  end
end
