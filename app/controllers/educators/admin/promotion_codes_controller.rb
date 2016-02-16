class Educators::Admin::PromotionCodesController < Educators::Admin::BaseController

  def index
    @promotion_codes = PromotionCode.all
  end

  def assign_code
    pc = PromotionCode.find(params[:promotion_code_id])
    pc.assign!
    redirect_to educators_admin_promotion_codes_path
  end

end
