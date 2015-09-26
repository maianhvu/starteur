class AddStateToAuthenticationToken < ActiveRecord::Migration
  def change
    add_column :authentication_tokens, :state, :string
  end
end
