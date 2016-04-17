class AccesscodeSender < ApplicationMailer
  default :from => 'hello@starteur.com'

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
        '-accessCode-' => ["#{@code}"],
        '-linkUrl-' => ["#{confirm_params[:host]}/dashboard/index#access-code"],
        '-linkCaption-' => ["Enter access code"]
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
    mail(:to => @user.email, :subject => 'Payment Success! View Access Code')
  end
end
