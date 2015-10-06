class AlterTimestampsForResults < ActiveRecord::Migration
  def change
    Result.all.each do |result|
      result.update_attributes(:created_at => Time.now, :updated_at => Time.now)
    end
    change_column :results, :created_at, :datetime, :null => false
    change_column :results, :updated_at, :datetime, :null => false
  end
end
