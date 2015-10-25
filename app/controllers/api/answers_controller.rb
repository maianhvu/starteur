module API
  class AnswersController < AuthenticatedController
    before_action :authenticate

    def create
      qids = []
      test = Test.find(params[:test_id])
      params.require(:answers).each_pair do |key, value|
        if ans = Answer.create(user: @user, question_id: key.to_i, value: value, test: test)
          qids << key.to_i
        end
      end
      # Completion status
      completed = @user.completed?(test)
      if completed
        usage = @user.code_usages.used.includes(:access_code).where('access_codes.test_id' => test.id).last
        usage.complete!
      end
      render json: { question_ids: qids, completed: @user.completed?(test) }, status: :ok
    end
  end
end
