class TestsController < ApplicationController

  include SQLHelper

  before_action :authenticate_user!, :check_if_already_completed
  layout 'tests'

  def begin
    if current_user.code_usages_for_test(params[:id]).empty?
      # When user has not activated a code for this test
      redirect_to dashboard_index_path
    else
      # Get the instruction file name that corresponds to the test name
      @test = Test.find(params[:id])
      test_instruction_file = @test.name.parameterize('_')
      @instruction_partial = "instructions/#{test_instruction_file}"
    end
  end

  def take
    @questions_url = test_questions_path(params[:id])
    @answers_url   = test_answers_path(params[:id])
    @finish_url    = dashboard_index_path
  end

  def check_if_already_completed
    result_exists = Result.exists?(user: current_user, test_id: params[:id])
    if result_exists
      # If result exists then redirect straight away
      redirect_to dashboard_index_path
    else
      # Now that result doesn't exist, probably it's not generated
      # To see whether it's indeed the case, we will now compare
      # the total number of questions against the total number of answers
      check_query = <<-SQL
      SELECT true WHERE
      (SELECT COUNT(*) FROM questions q WHERE q.test_id=#{params[:id]})<=
      (SELECT COUNT(*) FROM answers a WHERE a.test_id=#{params[:id]}
      AND a.user_id=#{current_user.id} AND a.result_id IS NULL)
      SQL
      all_answered = extract_boolean(raw_query(check_query))
      if all_answered
        # Generate result first then redirect
        # TODO: Perform the action described above
        redirect_to dashboard_index_path
      end
    end
  end
end
