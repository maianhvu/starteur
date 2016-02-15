class AddTestReferencesToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :test, index: true, foreign_key: true

    update_questions_query = <<-SQL
    UPDATE questions SET
    test_id=categories.test_id FROM categories
    WHERE category_id=categories.id
    SQL
    connection.execute(update_questions_query)
  end
end
