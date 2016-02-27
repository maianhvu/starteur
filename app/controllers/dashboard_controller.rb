class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard'

  def index
    # Define initial test status to complete
    @test_status = :completed

    # Created specifically for Starteur Profiling Assessment
    test = starteur_profiling_test

    # Find out if the user has any code_usage that belongs to this test
    if test
      @test_status = :code_not_entered
      @test_id = test.id
      # Query for code usages
      code_usages = CodeUsage.where(user: current_user, test: test)

      unless code_usages.empty?
        if !code_usages.select { |cu| cu[:state] == CodeUsage.states[:used] }.empty?
          # Check if the user is in the middle of taking a test
          if Answer.exists?(test: test, user: current_user, result_id: nil)
            @test_status = :uncompleted
          else
            @test_status = :code_entered
          end
        elsif !code_usages.select { |cu| cu[:state] == CodeUsage.states[:completed] }.empty?
          # This case happens when there is at least one completed code usage and where there is
          # no test in progress that is being referenced by all code usages
          # @test_status = :completed

          # Redirect to the report, since dashboard is now more or less useless
          redirect_to report_index_path
        end
      end

    end
  end

  private

  def starteur_profiling_test
    Test.published.where("name ILIKE '%Starteur Profiling Assessment%'").last
  end
end
