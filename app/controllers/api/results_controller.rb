module API
  class ResultsController < AuthenticatedController
    before_action :authenticate

    def index
      # identify test
      test = Test.find(params[:test_id])
      # expose results
      categories = test.categories.includes(:questions).map do |category|
        attrib = category.attributes.select do |k, v|
          [:id, :rank, :title, :description].include? k.intern
        end
        attrib[:questions] = category.questions.all.map do |question|
          question.attributes.select { |k, v| [:id, :polarity].include? k.intern }.symbolize_keys
        end
        attrib.symbolize_keys
      end
      answers = user.results.order('created_at DESC').find_by(:test_id => params[:test_id]).answers
      # require file
      processor_path = Rails.root.join('app', 'processors', "#{test.processor_file}.rb")
      require processor_path
      # include the class
      self.class.class_eval do
        include Processor
      end
      # process result
      content = Processor.process({
        :categories => categories,
        :answers => answers
      })
      render json: content, status: :ok
    end
  end
end
