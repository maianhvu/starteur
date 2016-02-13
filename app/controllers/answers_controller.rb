class AnswersController < ApplicationController

  before_action :authenticate_user!

  def create
    answers = answers_create_params

    # Get question ids
    question_ids = answers.keys
    # TODO: Find if answers to these questions already existed

    # Parse values into SQL format
    values_to_insert = question_ids.map { |key|
      values = [current_user.id, params[:test_id], key, answers[key]].join(', ')
      "(#{values})"
    }.join(', ')

    insert_query = <<-SQL
    INSERT INTO answers(user_id, test_id, question_id, value) VALUES
    #{values_to_insert}
    SQL
    ActiveRecord::Base.connection.execute(insert_query)

    render json: question_ids.to_json, status: :ok
  end

  private

  def answers_create_params
    params.require(:values)
  end
end
