class Educators::AdminsController < ApplicationController

  def index
  end

  def new
    @admin = Administrator.new
  end

  def create
  end

  private

  def admin_params
    params.require(:admin).permit(:name, :email)
  end
end
