module API
  class ResultsController < AuthenticatedController
    before_action :authenticate

    def index
      # identify test
      test = Test.find(params[:test_id])
      # Expose results
      @categories = test.categories
      @result = user.results.where(:test_id => params[:test_id]).order('created_at DESC').limit(1)
      @content = nil
      processor_path = Rails.root.join('app', 'processors', "#{test.processor_file}.rb")
      require processor_path
      render json: @content, status: :ok
    end
  end
end
