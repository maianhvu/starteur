class QuestionsController < ApplicationController

  include SQLHelper
  before_action :authenticate_user!

  def index
    # Query for unanswered questions
    query_string = <<-SQL
    SELECT q.content, q.choices, q.polarity FROM questions q, categories c
    WHERE q.category_id=c.id AND c.test_id=#{params[:test_id]}
    AND q.id NOT IN (
      SELECT a.question_id FROM answers a
      WHERE a.user_id=#{current_user.id} AND a.test_id=#{params[:test_id]}
      AND a.result_id IS NULL
    )
    SQL
    questions = raw_query(query_string)
    unless questions.empty?
      # TODO: Show questions
    end
  end

end
