class Educators::EducatorMailer < ApplicationMailer

  def reset_password_email(user)
    @name = [user.first_name, user.last_name].join(' ')
    @url = edit_password_reset_url(user.reset_password_token)
    mail to: user.email, subject: 'Password Reset'
  end

end
