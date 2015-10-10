class Educators::AdminSessionsController < Educators::BaseController

  def new
    @admin = Admin.new
  end

  def create
    if @admin = login(params[:email], params[:password])
      redirect_to educators_admin_path(@admin)
    else
      render :new
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:email, :password)
  end
end