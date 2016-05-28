class Educators::UserMailer < ApplicationMailer
  default :from => 'hello@starteur.com'

  def batch_test_reminder(email, test_name = nil)
    @test_name = test_name
    mail to: email, subject: 'Test reminder'
  end

  def send_code_usage(email, code_usage, batch)
    @batch = batch
    @code_usage = code_usage
    @email = email
    headers['X-SMTPAPI'] = {
      sub: {
      "-headerText-" => ["Hello! Welcome to Starteur."],
      "-linkUrl-" => ["#{root_url}"],
      "-linkCaption-" => ["Get Started!"]
      },
      filters: {
        templates: {
           settings: {
              enable: 1,
              template_id: "44922231-079f-4fac-961d-2b33bbb82e7f"
              }
            }
          }
    }.to_json
   mail(:to => @email, :subject => 'Welcome to Starteur! Access Your Test Now.')
  end

  def request_access_permission(email, batch)
    @email = email
    @batch = batch
    mail to: email, subject: 'Starteur test access'
  end

  def request_access_permission_after_signup(email, batch)
    @email = email
    @batch = batch
    mail to: email, subject: 'Starteur test access'
  end

end
