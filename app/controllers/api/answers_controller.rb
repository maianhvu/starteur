module API
  class AnswersController < AuthenticatedController
    before_action :authenticate

    def create
      errors = nil
      qids = []
      params.require(:answers).each do |choice_id|
        if ans = Answer.create(user: @user, choice_id: choice_id)
          qids << Choice.find(choice_id).question.id
        else
          errors = ans.errors
          break
        end
      end
      respond_to do |format|
        format.json {
          unless errors
            # Return answered questions ids
            render json: { question_ids: qids }, status: :ok
          else
            render json: { errors: errors.messages }, status: :unprocessable_entity
          end
        }
      end

    end
  end
end
