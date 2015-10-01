class ConfirmationSender < ApplicationMailer
  default :from => 'hello@starteur.com'

  def send_confirmation_email(user)
    @user = user
    confirm_params = {
      :escaped_email => user.email,
      :token => user.confirmation_token,
      :host => 'http://starteur1-2.herokuapp.com'
    }
    headers['X-SMTPAPI'] = {
      sub: {
        '-headerText-': ["Hi #{user.first_name}, thanks for registering with Starteur!"],
        '-linkUrl-': [Rails.application.confirm_url(confirm_params)],
        '-linkCaption-': ["Confirm email address"]
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "c1c0d6c4-173e-4249-ba1c-b6a785512025"
          }
        }
      }
    }.to_json
    mail(:to => @user.email, :subject => 'Welcome to Starteur! Confirm Your Email')
  end
end
