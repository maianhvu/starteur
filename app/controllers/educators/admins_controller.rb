class Educators::AdminsController < Educators::BaseController

  def index
  end

  def new
    @admin = Admin.new
  end

  def create
  end

  private

  def admin_params
    params.require(:admin).permit(:name, :email)
  end
end
