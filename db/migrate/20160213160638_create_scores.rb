class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.references :user, index: true, foreign_key: true
      t.references :test, index: true, foreign_key: true
      t.references :result, index: true, foreign_key: true
      t.integer :value
      t.integer :upon, :default => 100
    end
  end
end
