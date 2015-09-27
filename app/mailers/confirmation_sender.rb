class ConfirmationSender < ApplicationMailer
  default :from => 'hello@starteur.com'

  def send_confirmation_email(user)
    @user = user
    @confirm_params = {
      :escaped_email => Rack::Utils.escape(user.email),
      :token => user.confirmation_token,
      :host => 'https://www.starteur.com'
    }
    headers['X-SMTPAPI'] = {
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: "c1c0d6c4-173e-4249-ba1c-b6a785512025"
          }
        }
      }
    }.to_json
    mail(:to => @user.email, :subject => 'Welcome Aboard!')
  end
end
