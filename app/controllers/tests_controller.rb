class TestsController < ApplicationController

  before_action :authenticate_user!
  layout 'dashboard'

  def begin
    # Query for existence of code usage
    query_string = <<-SQL
    SELECT true WHERE EXISTS (
    SELECT * FROM code_usages cu, access_codes ac
    WHERE cu.access_code_id=ac.id AND ac.test_id=#{params[:id]}
    )
    SQL
    query_result = ActiveRecord::Base.connection.execute(query_string)
    # Postgres requires to get values
    query_result = query_result.values if query_result.respond_to? :values
    if query_result.empty?
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
    render plain: 'hello world!'
  end
end
