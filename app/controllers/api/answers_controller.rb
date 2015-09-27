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
      completed = false
      unless qids.empty?
        total = test.questions.count
        user_answers_for_test = @user.answers.where(test: test)
        done  = user_answers_for_test.count
        completed = done >= total
        # Build result if completed
        if completed
          answers_hash = {}
          user_answers_for_test.includes(:choice).all.each do |ans|
            answers_hash[ans.choice_id] = ans.choice.points
          end
          # Create result object
          Result.create!(answers: answers_hash, user: @user, test: test)
          # Remove temporary answer objects
          user_answers_for_test.destroy_all
        end
      end
      respond_to do |format|
        format.json {
          render json: { question_ids: qids, completed: completed }, status: :ok
        }
      end

    end
  end
end
