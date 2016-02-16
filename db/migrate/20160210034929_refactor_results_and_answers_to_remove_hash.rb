class RefactorResultsAndAnswersToRemoveHash < ActiveRecord::Migration
  def up
    remove_column :results, :answers
    add_reference :answers, :result, index: true
    execute "DROP EXTENSION IF EXISTS hstore"
  end

  def down
    execute "CREATE EXTENSION IF NOT EXISTS hstore"
    remove_column :answers, :result_id
    add_column :results, :answers, :hstore
  end
end
