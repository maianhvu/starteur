class AuthenticatedController < ApplicationController

  protected

  def authenticate
    authenticate_token
  end

  private

  def authenticate_token
    return false unless authenticate_params[:email]
    authenticate_or_request_with_http_token do |token, options|
      u = User.find_by(authenticate_params)
      u && u.authentication_tokens.in_use.find_by(token: token)
    end
  end

  def request_http_token_authentication(realm = "Application")
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    respond_to do |format|
      format.json { render json: { errors: [ 'Bad credentials' ] }, status: :unauthorized }
    end
  end

  def authenticate_params
    params.require(:user).permit(:email)
  end
end
