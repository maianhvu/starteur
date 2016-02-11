class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard'

  def index
    # Define initial test status to complete
    @test_status = :completed
    # Created specifically for Starteur Profiling Assessment
    test = Test.published.where("name ILIKE '%Starteur Profiling Assessment%'").last
    # Find out if the user has any code_usage that belongs to this test
    if test
      @test_status = :code_not_entered
      @test_id = test.id
      # Query for code usages
      code_usages = current_user.code_usages_for_test(test.id)
      if !code_usages.select { |cu| cu[:state] == CodeUsage.states[:used] }.empty?
        @test_status = :code_entered
      elsif !code_usages.select { |cu| cu[:state] == CodeUsage.states[:completed] }.empty?
        @test_status = :completed
      end
    end
  end
end
