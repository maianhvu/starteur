class AddStateToEducators < ActiveRecord::Migration
  def change
    add_column :educators, :state, :integer
  end
end
