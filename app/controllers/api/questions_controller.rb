module API
  class QuestionsController < AuthenticatedController
    before_action :authenticate

    def index
      test = Test.find(params[:test_id])
      if code = test.access_codes.find_by(code: code_params)
        unless test
          @questions = []
        else
          # Get answered questions
          u = User.find_by(user_params)
          answered = u.answers.where(test_id: test.id).map(&:question_id)
          @questions = test.questions
          # Filter out unanswered
          if answered && !answered.empty?
            @questions = @questions.where('questions.id NOT IN (?)', answered)
          end
          @questions = @questions.shuffled if test.shuffle
          @questions = @questions.ranked
        end
        render 'index.json.jbuilder', :status => :ok
      else
        render_auth_error('Application', 'Access code mismatch')
      end
    end

    private

    def user_params
      params.require(:user).permit(:email)
    end

    def code_params
      params.require(:accessCode)
    end
  end
end
