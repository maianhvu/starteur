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
          head :created
        else
          errors = parse_errors(usage.errors)
        end
      else
        errors = 'Invalid access code'
      end
      if errors
        render json: { errors: errors }, status: :unprocessable_entity
      end
    end
  end
end
