class TestsController < ApplicationController

  before_action :authenticate_user!
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
  end
end
