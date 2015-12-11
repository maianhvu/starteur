class Educators::EducatorsController < Educators::BaseController

  skip_before_action :require_login, only: [:new, :create]
  skip_before_action :prepare_educator, only: [:index, :new, :create]

  def index
  end

  def new
    @educator = Educator.new
  end

  def create
    @educator = Educator.new(educator_params)

    if @educator.save
      redirect_to educators_login_path, notice: 'Account successfully created'
    else
      flash.now[:error] = @educator.errors.full_messages.join(", ")
      render :new
    end
  end

  def show
    @batches = @educator.batches
  end

  def edit
  end

  def update
    if @educator.update_attributes(update_educator_params)
      redirect_to educators_educator_path(@educator), notice: "Update successful"
    else
      render :edit
    end
  end

  private

  def educator_params
    params.require(:educator).permit(:email, :password, :password_confirmation)
  end

  def update_educator_params
    params.require(:educator).permit(:first_name, :last_name, :organization, :title, :secondary_email)
  end

end
