class ChargesController < ApplicationController

  layout "application"
  layout "dashboard"
  PRICE_TEST_DEFAULT = 1500


  def new
  end

  def create
    # Amount in cents
    @amount = PRICE_TEST_DEFAULT
    @test = Test.find_by(identifier: "starteur_profiling_assessment")
    @test_id = @test.id

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )

    # Create access code
    access_code = AccessCode.create(code: generate_code, test_id: @test.id)
    @code = AccessCode.last.code
    AccesscodeSender.send_accesscode_email(current_user).deliver_now

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


   rescue Stripe::CardError => e
   flash[:error] = e.message
   redirect_to new_charge_path


end

 def generate_code
     random_token = SecureRandom.hex(n=4).downcase
 end

end
