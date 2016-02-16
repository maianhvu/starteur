class Educators::Admin::DiscountCodesController < Educators::Admin::BaseController

  def index
    @discount_codes = DiscountCode.all
  end

  def assign_code
    dc = DiscountCode.find(params[:discount_code_id])
    dc.assign!
    redirect_to educators_admin_discount_codes_path
  end

end
