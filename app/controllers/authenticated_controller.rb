class AuthenticatedController < ApplicationController

  protected

  def authenticate
    authenticate_token
  end

  private

  def authenticate_token
    # Check email presence
    return false unless authenticate_params[:email]
    # Authenticate token
    authenticate_or_request_with_http_token do |token, options|
      # If user doesn't exist, fail
      return false unless @user = User.find_by(authenticate_params)
      tokens = @user.authentication_tokens
      # If token already in use, return true
      return true if tokens.in_use.find_by(token: token)
      # If token is fresh, mark it as use
      if t = tokens.fresh.find_by(token: token)
        t.use!
        return true
      end
      # If token is expired, require re-signin
      if tokens.expired.find_by(token: token)
        render_auth_error("Application", 'Expired token')
        return
      end
      false
    end
  end

  def render_auth_error(realm = "Application", message)
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    respond_to do |format|
      format.json { render json: { errors: [ message ] }, status: :unauthorized }
    end
  end

  def request_http_token_authentication(realm = "Application")
    render_auth_error(realm, 'Bad credentials')
  end

  def authenticate_params
    params.require(:user).permit(:email)
  end
end
