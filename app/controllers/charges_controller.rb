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

<<<<<<< eca838fcc9b5d15aa969351ca8ab09c9c095412d
<<<<<<< a6117a955ea1b1aba6eb313764389b987e4db5a8
=======
    accesscode_sender.send_accesscode_email(current_user).deliver_now

>>>>>>> complete access code generation
   rescue Stripe::CardError => e
=======
>>>>>> add stripe checkout page
    flash[:error] = e.message
    redirect_to new_charge_path


end

 def generate_code
     random_token = SecureRandom.urlsafe_base64(nil, false).downcase
 end

end
