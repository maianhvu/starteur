class ConfirmationSender < ApplicationMailer
  default :from => 'hello@starteur.com'

  def send_confirmation_email(user)
    @user = user
    confirm_params = {
      :escaped_email => user.email,
      :token => user.confirmation_token,
      :host => 'http://www.starteur.com'
    }
    headers['X-SMTPAPI'] = {
      sub: {
        "-headerText-" => ["Hi #{user.first_name}, thanks for registering with Starteur!"],
        "-linkUrl-" => ["#{confirm_params[:host]}/confirm/#{confirm_params[:escaped_email]}/#{confirm_params[:token]}"],
        "-linkCaption-" => ["Confirm email address"]

      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "c8182604-b48b-46b9-aa25-65f340379519"
          }
        }
      }
    }.to_json
    mail(:to => @user.email, :subject => 'Welcome to Starteur! Confirm Your Email')
  end
end
