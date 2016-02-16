class MoveSorceryPasswordResetToEducators < ActiveRecord::Migration
  def change
    remove_column :users, :reset_password_token, :string, :default => nil
    remove_column :users, :reset_password_token_expires_at, :datetime, :default => nil
    remove_column :users, :reset_password_email_sent_at, :datetime, :default => nil

    add_column :educators, :reset_password_token, :string, :default => nil
    add_column :educators, :reset_password_token_expires_at, :datetime, :default => nil
    add_column :educators, :reset_password_email_sent_at, :datetime, :default => nil

    add_index :educators, :reset_password_token
  end
end
