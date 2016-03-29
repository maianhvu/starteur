class Educators::Admin::AdminsController < Educators::Admin::BaseController

  before_action :prepare_access_code_params, only: [:generate_access_code]
  before_action :prepare_discount_code_params, only: [:generate_discount_code]
  before_action :prepare_promotion_code_params, only: [:generate_promotion_code]
  before_action :prepare_transfer_access_code_params, only: [:transfer_access_codes]

  def index
    @educator_total = Educator.all.count
    @batch_total = Batch.all.count
    @user_total = User.all.count
    @test_total = CodeUsage.completed.count
  end

  def payment_history
    @billing_records = BillingRecord.all
  end

  def generate_codes
    @tests = Test.all
  end

  def manage_access_codes
    @access_codes = @educator.access_codes
    @educators = Educator.where.not(email: @educator.email)
  end

  def generate_access_code
    ac = AccessCode.new(test_id: params[:access_code][:test_id], permits: params[:access_code][:permits], educator: @educator)
    flash[:success] = ac.save ? 'Access code created' : ac.errors.full_messages.join(", ")
    redirect_to educators_admin_admins_path(@educator)
  end

  def generate_discount_code
    dc = DiscountCode.new(percentage: params[:discount_code][:percentage])
    flash[:success] = dc.save ? 'Discount code created' : dc.errors.full_messages.join(", ")
    redirect_to educators_admin_admins_path(@educator)
  end

  def generate_promotion_code
    pc = PromotionCode.new(test_id: params[:promotion_code][:test_id], quantity: params[:promotion_code][:quantity])
    flash[:success] = pc.save ? 'Promotion code created' : pc.errors.full_messages.join(", ")
    redirect_to educators_admin_admins_path(@educator)
  end

  def transfer_access_codes
    if params[:educator_id] && params[:access_code_ids]
      educator = Educator.find(params[:educator_id])
      params[:access_code_ids].each do |id|
        ac = AccessCode.find(id)
        ac.update_attributes({educator: educator})
      end
      flash[:success] = 'Codes successfully transferred'
      redirect_to educators_admin_admins_path(@educator)
    else
      flash[:warning] = 'At least 1 code needs to be selected'
      redirect_to educators_admin_admin_manage_access_codes_path(@educator)
    end
  end

  private

  def prepare_access_code_params
    params.require(:access_code).permit(:test_id, :permits)
  end

  def prepare_discount_code_params
    params.require(:discount_code).permit(:percentage)
  end

  def prepare_promotion_code_params
    params.require(:promotion_code).permit(:test_id, :quantity)
  end

  def prepare_transfer_access_code_params
    params.permit(:educator_id, access_code_ids: [])
  end

end
