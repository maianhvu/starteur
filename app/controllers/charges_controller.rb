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

    access_code = AccessCode.create(code: generate_code, test_id: @test.id)
    @code = AccessCode.last.code
    @test_status = :completed
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

   AccesscodeSender.send_accesscode_email(current_user).deliver_now

   rescue Stripe::CardError => e
   flash[:error] = e.message
   redirect_to new_charge_path


end

 def generate_code
     random_token = SecureRandom.hex(n=4).downcase
 end

end
