class CodeUsagesController < ApplicationController
  def create
    access_code = AccessCode.find_by(create_code_usage_params)
    if access_code
      # Add the access code to user
      code_usage = CodeUsage.new(access_code: access_code, test_id: access_code.test_id, email: current_user.email)
      code_usage.use(current_user)
      # Attempt to save the code
      if code_usage.save
        access_code.save!
        # Code is successfully used and now
        # user will be redirected to taking the test
        redirect_to begin_test_path(create_code_usage_params[:test_id])
      else
        # TODO: Add rescue to failed code_usage creation
      end
    else
      # TODO: Add rescue to failed access_code creation
    end
  end

  protected

  def create_code_usage_params
    params.require(:access_code).permit(:test_id, :code)
  end
end
