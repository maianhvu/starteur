class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.string :content
      t.integer :points
      t.integer :ordinal
      t.references :question, index: true, foreign_key: true
    end
  end
end
