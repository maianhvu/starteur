class AccesscodeSender < ApplicationMailer
  default :from => 'hello@starteur.com'

  MAILER_HOST_DEFAULT = ENV['MAIL_HOST']
  MAILER_TEMPLATE_CONFIRMATION = '55c680c0-6862-4286-a3ed-0653bb6c18ce'


  def send_accesscode_email(user)
    @user = user
    @code = AccessCode.last.code
    confirm_params = {
      :escaped_email => user.email,
      :host => 'http://www.starteur.com'
    }
    headers['X-SMTPAPI'] = {
      sub: {
        '-headerText-' => ["Hi #{user.first_name}, your purchase has been successful!"],
        '-linkUrl-' => ["#{confirm_params[:host]}/dashboard/index"],
        '-linkCaption-' => ["Take the Test"]
      },
      filters: {
        templates: {
          settings: {
            enable: 1,
            template_id: MAILER_TEMPLATE_CONFIRMATION
          }
        }
      }
    }.to_json
    mail(:to => @user.email, :subject => 'Purchase Success! Take the Starteur Quiz Now.')
  end
end
