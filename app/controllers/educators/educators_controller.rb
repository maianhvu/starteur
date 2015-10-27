class Educators::EducatorsController < Educators::BaseController

  skip_before_action :require_login, only: [:new, :create]
  skip_before_action :prepare_educator, only: [:index, :new, :create]

  def index
  end

  def new
    @educator = Educator.new
    render layout: 'educators/simple'
  end

  def create
    @educator = Educator.new(educator_params)

    if @educator.save
      redirect_to educators_login_path, notice: 'Account successfully created'
    else
      flash.now[:error] = @educator.errors.full_messages.join(", ")
      render :new, layout: 'educators/simple'
    end
  end

  private

  def educator_params
    params.require(:educator).permit(:email, :password, :password_confirmation)
  end
end
