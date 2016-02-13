class Educators::BaseController < ActionController::Base

  layout 'educators/application'

  before_action :require_login
  before_action :prepare_educator

  private

  # def not_authenticated
  #   redirect_to educators_login_path
  # end

  def prepare_educator
    @educator = current_user
  end

end
