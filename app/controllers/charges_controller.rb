class ChargesController < ApplicationController

  layout "application"
  layout "dashboard"


  def new
  end

  def create
    # Amount in cents
    @test = Test.find_by(identifier: "starteur_profiling_assessment")
    @test_id = @test.id
    @amount = @test.price.to_i * 100
    @final_amount = @amount

    code = params[:couponCode]

    if !code.nil?
      @coupon = Coupon.get(code)

      if @coupon.nil?
        flash[:error] = 'Coupon code is not valid or expired.'
        redirect_to dashboard_index_path
        return
      else
        @final_amount = @coupon.apply_discount(@amount.to_i)
        @discount_amount = (@amount - @final_amount)
      end

      charge_metadata = {
        :coupon_code => @coupon.code,
        :coupon_discount => @coupon.discount_percent_human
      }
    end

    charge_metadata ||= {}

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @final_amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd',
      :metadata    => charge_metadata
    )

    # Create charge record
    @charge = Charge.create!(amount: @final_amount, coupon: @coupon, stripe_id: charge.id)

    # Create access code
    access_code = AccessCode.create(code: generate_code, test_id: @test.id)
    @code = AccessCode.last.code

    # Create code usage
    code_usage = CodeUsage.new(access_code: access_code, test_id: access_code.test_id)
    code_usage.use(current_user)
    # Attempt to save the code
    if code_usage.save
      access_code.save!
      # Code is successfully used and now
      # user will be redirected to taking the test
    else
      # TODO: Add rescue to failed code_usage creation
    end

   AccesscodeSender.send_accesscode_email(current_user).deliver_now

   rescue Stripe::CardError => e
   flash[:error] = e.message
   redirect_to new_charge_path


end

 def generate_code
     random_token = SecureRandom.hex(n=4).downcase
 end

end
