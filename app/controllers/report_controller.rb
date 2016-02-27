class ReportController < ApplicationController
  layout 'report'

  def index
    # FIXME: Hard-coded to use Starteur Profiling Test
    test = starteur_profiling_test

    # Find the latest result of this test from the user
    result = Result.where(test: test, user: current_user).last

    # Execute processor file to get results
    processor_file_path = File.join(Rails.root, 'app', 'processors', test.processor_file)
    load processor_file_path
    result_processor = Processor.new(result.id)
    @processed_result = result_processor.process
  end

  private

  def starteur_profiling_test
    Test.published.where("name ILIKE '%Starteur Profiling Assessment%'").last
  end
end
