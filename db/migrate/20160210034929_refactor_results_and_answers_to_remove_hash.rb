class RefactorResultsAndAnswersToRemoveHash < ActiveRecord::Migration
  def up
    add_reference :answers, :result, index: true

    # Create answers first
    # Search for all results with actual answers
    results = Result.find_by_sql("SELECT * FROM results r WHERE r.answers IS NOT NULL")
    results.each do |result|
      answers_hash = result.answers
      answer_values = answers_hash.keys.map { |question_id|
        answer_value = answers_hash[question_id]
        "(#{result.user_id}, #{result.test_id}, #{question_id}, #{answer_value}, #{result.id})"
      }.join(', ')
      create_answers_query = <<-SQL
      INSERT INTO answers(user_id, test_id, question_id, value, result_id)
      VALUES #{answer_values}
      SQL
      connection.execute(create_answers_query)
    end

    # Then safely create results
    remove_column :results, :answers

    execute "DROP EXTENSION IF EXISTS hstore"
  end

  def down
    execute "CREATE EXTENSION IF NOT EXISTS hstore"
    add_column :results, :answers, :hstore
    Result.all.each do |result|
      answers = result.answers
      next unless answers.count > 0
      answers_hash = {}
      answers.each do |answer|
        answers_hash[answer.question_id] = answer.value
      end
      result.update_attributes(:answers, answers_hash)
    end

    remove_column :answers, :result_id
  end
end
