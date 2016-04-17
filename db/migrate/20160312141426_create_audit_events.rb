class CreateAuditEvents < ActiveRecord::Migration
  def change
    create_table :audit_events do |t|
      t.integer :action, index: true
      t.references :admin, references: :educators
      t.references :other, references: :educators
      t.string :comments

      t.timestamps null: false
    end
  end
end
