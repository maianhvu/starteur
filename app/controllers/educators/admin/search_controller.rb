class Educators::Admin::SearchController < Educators::Admin::BaseController

  def index
    num_per_page = 1 # number of items to be displayed PER page
    if search_params.any?
      @organisations = Kaminari.paginate_array(Educator.where("organisation like ?", "%#{search_params[:search_text]}%").pluck(:organisation)).page(params[:org_page]).per(num_per_page)
      @educator_emails = Educator.where("email like ? or lower(first_name) like ? or lower(last_name) like ?", "%#{search_params[:search_text]}%", "%#{search_params[:search_text].downcase}%", "%#{search_params[:search_text].downcase}%").page(params[:email_page]).per(num_per_page)
      @batches = Batch.where("lower(name) like ?", "%#{search_params[:search_text].downcase}%").page(params[:batch_page]).per(num_per_page)
      @users = User.where("email like ? or lower(first_name) like ? or lower(last_name) like ?", "%#{search_params[:search_text]}%", "%#{search_params[:search_text].downcase}%", "%#{search_params[:search_text].downcase}%").page(params[:user_page]).per(num_per_page)
    end
  end

  private

  def search_params
    params.permit(:search_text)
  end

end
