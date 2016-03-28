module StarteurWebappHelper

  def sign_in_using(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end

  def sign_out
    visit dashboard_index_path unless current_path.eql?(dashboard_index_path)
    click_link 'Sign out'
  end
end
