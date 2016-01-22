class Educators::EducatorMailer < ApplicationMailer

  def reset_password_email(user)
    @name = user.name || 'Educator'
    @url = edit_educators_password_reset_url(user.reset_password_token)
    mail to: user.email, subject: 'Password Reset'
  end

  def batch_completion_email(educator, batch_name)
    @batch_name = batch_name
    mail to: educator.email, subject: 'Batch completion'
  end

end
