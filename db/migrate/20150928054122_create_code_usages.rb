class CreateCodeUsages < ActiveRecord::Migration
  def change
    create_table :code_usages do |t|
      t.references :access_code, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
