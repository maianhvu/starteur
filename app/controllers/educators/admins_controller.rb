class Educators::AdminsController < Educators::BaseController

  def index
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      redirect_to educators_login_path
    else
      raise @admin.errors.inspect
      render :new
    end
  end

  def show
  end

  private

  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation)
  end
end
