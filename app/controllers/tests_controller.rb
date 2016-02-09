class TestsController < ApplicationController

  def begin
    query_string = <<-SQL
    SELECT true WHERE EXISTS (
    SELECT * FROM code_usages cu, access_codes ac
    WHERE cu.access_code_id=ac.id AND ac.test_id=#{params[:id]}
    )
    SQL
    query_result = ActiveRecord::Base.connection.execute(query_string)
    query_result = query_result.values if query_result.respond_to? :values
    redirect_to dashboard_index_path if query_result.empty?
  end
end
