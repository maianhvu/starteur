class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :expire_hsts
  protect_from_forgery with: :exception

  protected

  def expire_hsts
    response.headers["Strict-Transport-Security"] = 'max-age=0'
  end

  def after_sign_in_path_for(resource)
    :dashboard_index
  end
end
