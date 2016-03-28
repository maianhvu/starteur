class AddIdentifierToTest < ActiveRecord::Migration
  def change
    # Add column first
    add_column :tests, :identifier, :string

    # Generate default identifier for tests
    Test.all.each do |test|
      identifier = test.name.downcase.gsub(/\s+/, "_").gsub(/\W/,"")
      test.identifier = identifier
      test.save!
    end

    # Set identifier to not null
    change_column :tests, :identifier, :string, :null => false

    # Add unique index
    add_index :tests, :identifier, :unique => true
  end
end
