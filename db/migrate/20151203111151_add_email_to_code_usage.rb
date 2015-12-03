class AddEmailToCodeUsage < ActiveRecord::Migration
  def change
  	add_column :code_usages, :email, :string
  end
end
