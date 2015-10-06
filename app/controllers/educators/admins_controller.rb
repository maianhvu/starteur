class Educators::AdminsController < ApplicationController

  def index
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      redirect_to educators_admins_path
    else
      raise @admin.errors.inspect
      render :new
    end
  end

  def show
  end

  private

  def admin_params
    params.require(:admin).permit(:name, :email, :crypted_password)
  end
end
