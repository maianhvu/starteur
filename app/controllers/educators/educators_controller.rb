class Educators::EducatorsController < Educators::BaseController

  skip_before_action :prepare_educator, only: [:index, :new, :create]

  def index
  end

  def new
    @educator = Educator.new
    render layout: 'educators/simple'
  end

  def create
  end

  private

  def educator_params
    params.require(:educator).permit(:name, :email)
  end
end
