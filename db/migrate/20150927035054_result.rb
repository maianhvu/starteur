class Result < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.hstore :answers
      t.references :user, index: true, foreign_key: true
      t.references :test, index: true, foreign_key: true
    end
  end
end
