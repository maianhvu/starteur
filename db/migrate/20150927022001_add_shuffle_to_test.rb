class AddShuffleToTest < ActiveRecord::Migration
  def change
    add_column :tests, :shuffle, :boolean, :default => false
  end
end
