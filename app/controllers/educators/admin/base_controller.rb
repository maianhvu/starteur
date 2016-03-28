class Educators::Admin::BaseController < Educators::BaseController

  before_action :verify_admin

  private

  def verify_admin
    unless @educator.admin
      flash[:error] = 'Unauthorised'
      redirect_to educators_educators_path
    end
  end

end
