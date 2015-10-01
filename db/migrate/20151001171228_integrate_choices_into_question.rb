class IntegrateChoicesIntoQuestion < ActiveRecord::Migration
  def change
    # remove choices
    execute "DROP TABLE choices CASCADE"
    # remove reference from answers
    remove_column :answers, :choice_id
    # add reference directly to question
    add_reference :answers, :question, index: true, foreign_key: true
    # add choices as an array
    add_column :questions, :choices, :string, array: true
    add_index :questions, :choices, using: 'gin'
    # add polarity
    add_column :questions, :polarity, :integer, default: 1
  end
end
