class AuthenticatedController < ApplicationController

  def allow
    cors_preflight_check
  end

  protected

  def authenticate
    authenticate_token
  end

  def authenticate_params
    params.require(:user).permit(:email)
  end

  def user
    @user || User.find_by(authenticate_params)
  end

  def render_auth_error(realm = "Application", message)
    headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    headers["Access-Control-Allow-Origin"] = '*'
    render json: { errors: message, errorFields: [] }, status: :unauthorized
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
      # If token is fresh or in_use
      token_states = [:fresh, :in_use].map { |s| AuthenticationToken.states[s] }
      if t = tokens.where('authentication_tokens.state IN (?)', token_states).find_by(token: token)
        t.use!
        return true unless t.expired?
      end
      # If token is expired, require re-signin
      if (t && t.expired?) || tokens.expired.find_by(token: token)
        render_auth_error("Application", 'Expired token')
        return
      end
      false
    end
  end

  def request_http_token_authentication(realm = "Application")
    render_auth_error(realm, 'Bad credentials')
  end
end
