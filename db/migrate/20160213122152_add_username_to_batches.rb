class AddUsernameToBatches < ActiveRecord::Migration
  def change
  	add_column :batches, :username, :hstore, default: {}, null: false
  end
end
