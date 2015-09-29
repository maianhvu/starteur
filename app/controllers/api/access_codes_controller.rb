module API
  class AccessCodesController < AuthenticatedController

    before_action :authenticate

    def use
      test = Test.find(params[:test_id])
      code = AccessCode.find_by(code: params[:code])
      errors = nil
      if test && code && code.test == test
        usage = CodeUsage.new(access_code: code)
        if usage.save
          usage.use!(user)
          respond_to do |format|
            format.json { head :created }
          end
        else
          errors = usage.errors.full_messages.join('. ')
        end
      else
        errors = 'Invalid access code'
      end
      if errors
        respond_to do |format|
          format.json {
            render json: { errors: errors }, status: :unprocessable_entity
          }
        end
      end
    end
  end
end
