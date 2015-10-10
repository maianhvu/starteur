class Educators::BaseController < ActionController::Base

  layout 'educators/application'

  def current_user
    sorcery_current_user
  end

end
