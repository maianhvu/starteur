class Educators::Admin::SearchController < Educators::Admin::BaseController

  def index
    if search_params.any?
      @organisations = Educator.where("organisation like ?", "%#{search_params[:search_text]}%").pluck(:organisation)
      @educator_emails = Educator.where("email like ? or lower(first_name) like ? or lower(last_name) like ?", "%#{search_params[:search_text]}%", "%#{search_params[:search_text].downcase}%", "%#{search_params[:search_text].downcase}%")
      @batches = Batch.where("lower(name) like ?", "%#{search_params[:search_text].downcase}%")
      @users = User.where("email like ? or lower(first_name) like ? or lower(last_name) like ?", "%#{search_params[:search_text]}%", "%#{search_params[:search_text].downcase}%", "%#{search_params[:search_text].downcase}%")
    end
  end

  private

  def search_params
    params.permit(:search_text)
  end

end
