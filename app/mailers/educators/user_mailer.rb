class Educators::UserMailer < ApplicationMailer

  def batch_test_reminder(email, test_name = nil)
    @test_name = test_name
    mail to: email, subject: 'Test reminder'
  end

  def send_code_usage(email, code_usage, batch)
    @batch = batch
    @code_usage = code_usage
    @email = email
    mail to: email, subject: 'Starteur test access'
  end

  def request_access_permission(email, batch)
    @email = email
    @batch = batch
    mail to: email, subject: 'Starteur test access'
  end

end
