class Educators::EducatorSessionsController < Educators::BaseController

  skip_before_action :require_login

  def new
    @educator = Educator.new
  end

  def create
    if @educator = login(params[:email], params[:password])
      redirect_to educators_educators_path(@educator)
    else
      render :new
    end
  end

  private

  def educator_params
    params.require(:educator).permit(:email, :password)
  end
end