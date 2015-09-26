module API
  class QuestionsController < AuthenticatedController
    before_action :authenticate

    def index
      @questions = Test.find(params[:test_id]).questions
      respond_to do |format|
        format.json { render :status => :ok }
      end
    end
  end
end
