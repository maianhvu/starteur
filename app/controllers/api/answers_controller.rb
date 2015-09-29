module API
  class AnswersController < AuthenticatedController
    before_action :authenticate

    def create
      errors = nil
      qids = []
      test = Test.find(params[:test_id])
      params.require(:answers).each do |choice_id|
        if ans = Answer.create(user: @user, choice_id: choice_id, test: test)
          qids << Choice.find(choice_id).question.id
        end
      end
      # Completion status
      completed = @user.completed?(test)
      if completed
        usage = CodeUsage.used.where(user: @user).includes(:access_code).find_by('access_codes.test_id' => test.id)
        usage.complete!
      end
      respond_to do |format|
        format.json {
          render json: { question_ids: qids, completed: @user.completed?(test) }, status: :ok
        }
      end

    end
  end
end
