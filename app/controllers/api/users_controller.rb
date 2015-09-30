module API
  class UsersController < AuthenticatedController

    before_action :authenticate, only: [ :show ]

    def create
      u = UserMember.create(register_params)
      if u.save
        # Create trial token
        token = AuthenticationToken.create!(user: u)
        # Send confirmation email
        ConfirmationSender.send_confirmation_email(u).deliver if ENV['RAILS_ENV'] == 'production'
        # Render success
        render json: { user: {
          email: u.email,
          token: token.token
        } }, status: :created
      else
        render json: {
          errors: u.errors.full_messages.join(', ')
        }, status: :unprocessable_entity
      end
    end

    def confirm
      u = User.find_by(email: params[:escaped_email].strip.downcase)
      if u.may_confirm?(params[:token])
        u.confirm!(params[:token])
        head :ok
      else
        render json: { errors: "Invalid confirmation token" }, status: :unprocessable_entity
      end
    end

    def sign_in
      u = User.find_by(email: sign_in_params[:email])
      if u && u.confirmed? && u.authenticate(sign_in_params[:password])
        if token = u.authentication_tokens.expired.first
          token.refresh!
        else
          token = u.authentication_tokens.fresh.first || AuthenticationToken.create!(user: u)
        end
        token.use!
        render json: { token: token.token }, status: :ok
      else
        render json: { errors: "User's email unconfirmed" }, status: :unprocessable_entity
      end
    end

    def show
      user = @user || User.find_by(authenticate_params)
      render json: {
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        confirmed: user.confirmed?
      }, status: :ok
    end

    private

    def register_params
      params.require(:user).permit(:email, :password, :first_name, :last_name, :type)
    end

    def sign_in_params
      params.require(:user).permit(:email, :password)
    end

  end
end
