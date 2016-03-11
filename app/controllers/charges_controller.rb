class ChargesController < ApplicationController

  PRICE_TEST_DEFAULT = 1500

  def new
  end

  def create
    # Amount in cents
    @amount = PRICE_TEST_DEFAULT

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

   access_code = AccessCode.create(code: generate_code)
   @code = AccessCode.last.code


  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

 def generate_code
     random_token = SecureRandom.urlsafe_base64(nil, false)
 end

end
