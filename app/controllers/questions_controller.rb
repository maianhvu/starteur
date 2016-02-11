class QuestionsController < ApplicationController

  include SQLHelper
  before_action :authenticate_user!

  def index
    # Query for unanswered questions
    query_string = <<-SQL
    SELECT q.id, q.content, q.choices, q.polarity, c.rank FROM questions q, categories c
    WHERE q.category_id=c.id AND c.test_id=#{params[:test_id]}
    AND q.id NOT IN (
      SELECT a.question_id FROM answers a
      WHERE a.user_id=#{current_user.id} AND a.test_id=#{params[:test_id]}
      AND a.result_id IS NULL
    ) ORDER BY c.rank, q.ordinal
    SQL
    @questions = Question.find_by_sql(query_string)

    # Shuffle questions if the test specifies so
    # TODO: Add shuffle test option

    # Query for number of questions answered
    query_string = <<-SQL
    SELECT COUNT(*) FROM answers a
    WHERE a.user_id=#{current_user.id} AND a.test_id=#{params[:test_id]}
    AND a.result_id IS NULL
    SQL
    @answered_count = extract_count(raw_query(query_string))
  end

end
