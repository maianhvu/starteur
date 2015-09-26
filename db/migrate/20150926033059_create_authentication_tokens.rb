class CreateAuthenticationTokens < ActiveRecord::Migration
  def change
    create_table :authentication_tokens do |t|
      t.string :token
      t.references :user, index: true, foreign_key: true
      t.datetime :expires_at
      t.datetime :last_used_at

      t.timestamps null: false
    end
  end
end
