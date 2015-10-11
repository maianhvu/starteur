class Educators::BaseController < ActionController::Base

  layout 'educators/application'

  before_action :require_login

  private

  def not_authenticated
    redirect_to educators_login_path
  end

end
