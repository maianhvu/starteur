module API
  class QuestionsController < AuthenticatedController
    before_action :authenticate

    def index
      test = Test.find(params[:test_id])
      unless test
        @questions = []
      else
        # Get answered questions
        u = User.find_by(index_params)
        answered = u.answers.map(&:choice).map(&:question_id)
        @questions = test.questions
        # Filter out unanswered
        if answered && !answered.empty?
          @questions = @questions.where('questions.id NOT IN (?)', answered)
        end
        @questions = @questions.shuffled if test.shuffle
        @questions = @questions.ranked.includes(:choices)
      end
      respond_to do |format|
        format.json { render :status => :ok }
      end
    end

    private

    def index_params
      params.require(:user).permit(:email)
    end
  end
end
