class AddStateToCodeUsage < ActiveRecord::Migration
  def change
    add_column :code_usages, :state, :integer
  end
end
