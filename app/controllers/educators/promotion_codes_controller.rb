class Educators::PromotionCodesController < Educators::BaseController

  def index
  end

  def redeem_code
    pc = PromotionCode.find_by(code: params[:code])
    if pc && pc.access_code.nil?
      ac = AccessCode.new(test: pc.test, permits: pc.quantity, educator: @educator, promotion_code: pc)
      if ac.save
        flash[:success] = 'Promotion Code has been successfully redeemed'
      else
        flash[:error] = ac.errors.full_messages.join(', ')
      end
    else
      flash[:error] = 'Promotion code is invalid or has already been redeemed'
    end
    redirect_to educators_educator_path(@educator)
  end

end
