class ReportController < ApplicationController
  include ProcessorHelper

  layout 'report'

  STRING_DELIMITER_SENTENCES = '. '
  COUNT_POTENTIAL_SENTENCES = 2
  COUNT_ROLE_SENTENCES = 3

  before_action :authenticate_user!, :retrieve_report_data

  def view

    # Perform special actions on index page of report
    if params[:view].eql?('index')
      # Display only the first few sentences of each role in the
      # main report page
      @report_data[:top_roles].each do |attribute|
        attribute[:description] = extract_sentences(attribute[:description], COUNT_ROLE_SENTENCES)
      end

      # Same for the potential
      potential_description = extract_sentences(@report_data[:potential][:description], COUNT_POTENTIAL_SENTENCES)
      @report_data[:potential][:description] = potential_description
    end

    render "report/#{current_test.identifier}/#{params[:view]}"
  end

  private

  def current_test
    # FIXME: Hard-coded to use Starteur Profiling Test
    @test = starteur_profiling_test
  end

  def retrieve_report_data
    @report_data = test_result_for(current_test)
  end

  def test_result_for(test)
    # Cache result
    cache_key = "user#{current_user.id}:test#{test.id}:result"

    Rails.cache.fetch(cache_key) do
      # Find the latest result of this test from the user
      result = Result.where(test: test, user: current_user).last

      # Execute processor file to get results
      # Method load_processor_for can be found inside ProcessorHelper
      load_processor_for(test)
      result_processor = Processor.new(result)

      # Return processed result
      result_processor.process
    end
  end

  def extract_sentences(paragraph, num_sentences)
    # Select the first paragraph if is an array
    paragraph = paragraph.first if paragraph.is_a? Array
    # Split out sentences
    sentences = paragraph.split(STRING_DELIMITER_SENTENCES)
    # Take only the first `num_sentences` of sentences
    sentences = sentences.first(num_sentences)

    # Join back and append one extra delimiter to the end
    # (minus trailing spaces)
    paragraph = sentences.join(STRING_DELIMITER_SENTENCES)
    paragraph << STRING_DELIMITER_SENTENCES.rstrip

    # Return the new paragraph
    paragraph
  end

  def starteur_profiling_test
    Test.find_by(identifier: 'starteur_profiling_assessment')
  end

end
