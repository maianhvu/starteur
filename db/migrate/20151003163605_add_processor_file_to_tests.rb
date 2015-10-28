class AddProcessorFileToTests < ActiveRecord::Migration
  def change
    add_column :tests, :processor_file, :string
    Test.all.each do |t|
      t.update_attribute(:processor_file, t.name.downcase.gsub(/\s+/,'_'))
    end
  end
end
