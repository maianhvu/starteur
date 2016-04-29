# author: Mai Anh Vu <vu@reactor.sg>
# ----------------------------------
# This class is an override of the default Devise::Mailer, and it handles mail
# sending for devise-based actions
#
class StarteurDeviseMailer < Devise::Mailer

  #
  # Constants
  #
  MAILER_HOST_DEFAULT = ENV['MAIL_HOST']
  MAILER_TEMPLATE_CONFIRMATION = 'c8182604-b48b-46b9-aa25-65f340379519'

  #
  # Configuration
  #
  # helper :application # Give access to all application helpers
  include Devise::Controllers::UrlHelpers # To be able to use Devise routes
  default template_path: 'users/mailer' # Make sure this mailer use customised Devise views

  # This method is called by default when Devise sends a confirmation email to
  # newly registered users. In here, we are setting up headers for SendGrid to
  # send the correct email template.
  def confirmation_instructions(user, token, options = {})
    headers['X-SMTPAPI'] = {
      sub: {
        '-headerText-' => ["Hi #{user.first_name}, thanks for registering with Starteur!"],
        '-linkUrl-' => [confirmation_url(user, confirmation_token: token)],
        '-linkCaption-' => ["Confirm email address"]
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

    super
  end

end
