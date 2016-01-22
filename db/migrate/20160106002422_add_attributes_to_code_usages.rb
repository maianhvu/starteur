class AddAttributesToCodeUsages < ActiveRecord::Migration
  def change
    add_column :code_usages, :email, :string
    add_column :code_usages, :uuid, :string
  end
end
