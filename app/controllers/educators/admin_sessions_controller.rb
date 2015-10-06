class Educators::AdminSessionsController < Educators::BaseController

  def new
    @admin = Admin.new
  end

  def create
    if login(params[:email], params[:password])
      redirect_to educators_admin_path(Admin.find_by(email: params[:email]))
    else
      render :new
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:name, :email, :crypted_password)
  end
end