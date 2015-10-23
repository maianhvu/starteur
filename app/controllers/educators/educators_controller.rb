class Educators::EducatorsController < Educators::BaseController

  def index
  end

  def new
    @educator = Educator.new
  end

  def create
  end

  private

  def educator_params
    params.require(:educator).permit(:name, :email)
  end
end
