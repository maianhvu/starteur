module API
  class QuestionsController < AuthenticatedController
    before_action :authenticate

    def index
      test = Test.find(params[:test_id])
      if code = test.access_codes.find_by(code: code_params)
        @questions = []
        if test
          # Get answered questions
          u = User.find_by(user_params)
          answered = u.answers.where(test_id: test.id).map(&:question_id)
          # Find categories in order first
          test.categories.ranked.all.each do |category|
            # Get current category's question
            # Notice the missing @ sign, the two variables are different!
            questions = category.questions
            questions = questions.shuffled if test.shuffle
            # Filter out unanswered
            if answered && !answered.empty?
              questions = questions.where('questions.id NOT IN (?)', answered)
            end
            # Append to all questions
            @questions.push(*questions)
          end
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
