class ChargesController < ApplicationController

  layout "application"
  layout "dashboard"
  PRICE_TEST_DEFAULT = 1500


  def new
  end

  def create
    # Amount in cents
    @amount = PRICE_TEST_DEFAULT
    access_code = AccessCode.create(code: generate_code)
    @code = AccessCode.last.code
    @test_status = :completed
    @test = Test.find(id=1)
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'sgd'
    )

   rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path


end

 def generate_code
     random_token = SecureRandom.urlsafe_base64(nil, false).downcase
 end

end
