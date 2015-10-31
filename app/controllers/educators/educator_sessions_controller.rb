class Educators::EducatorSessionsController < Educators::BaseController

  layout 'educators/simple'

  skip_before_action :require_login
  skip_before_action :prepare_educator, only: [:new, :create]

  def new
    @educator = Educator.new
  end

  def create
    if @educator = login(params[:email], params[:password])
      redirect_to educators_educator_path(@educator)
    else
      flash.now[:error] = 'Invalid username or password'
      render :new
    end
  end


  def destroy
    logout
    redirect_to educators_root_path
  end
end
