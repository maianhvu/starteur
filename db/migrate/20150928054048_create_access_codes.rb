class CreateAccessCodes < ActiveRecord::Migration
  def change
    create_table :access_codes do |t|
      t.string :code
      t.references :test, index: true, foreign_key: true
      t.datetime :last_used_at
      t.boolean :universal

      t.timestamps null: false
    end
  end
end
