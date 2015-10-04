module API
  class ResultsController < AuthenticatedController
    before_action :authenticate

    def index
      # identify test
      test = Test.find(params[:test_id])
      # expose results
      categories = test.categories
      result = user.results.where(:test_id => params[:test_id]).order('created_at DESC').limit(1)
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
        :result => result
      })
      render json: @content, status: :ok
    end
  end
end
