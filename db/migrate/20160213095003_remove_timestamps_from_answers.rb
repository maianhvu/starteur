class RemoveTimestampsFromAnswers < ActiveRecord::Migration
  def self.up
    remove_column :answers, :created_at
    remove_column :answers, :updated_at
  end

  def self.down
    add_column :answers, :created_at, :timestamp
    add_column :answers, :updated_at, :timestamp
  end
end
