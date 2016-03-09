class RemoveProcessorFileFromTests < ActiveRecord::Migration
  def self.up
    remove_column :tests, :processor_file
  end

  def self.down
    add_column :tests, :processor_file, :string
  end
end
