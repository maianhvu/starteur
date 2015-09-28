module API
  class UsersController < AuthenticatedController

    before_action :authenticate, only: [ :show ]

    def create
      u = UserMember.create(register_params)
      if u.save
        # Create trial token
        token = AuthenticationToken.create!(user: u)
        # Send confirmation email
        ConfirmationSender.send_confirmation_email(u).deliver
        # Render success
        respond_to do |format|
          format.json { render json: { user: {
            email: u.email,
            first_name: u.first_name,
            token: token.token
          } }, status: :created }
        end
      else
        respond_to do |format|
          format.json { render json: u.errors.messages, status: :unprocessable_entity }
        end
      end
    end

    def confirm
      u = User.find_by(email: params[:escaped_email].strip.downcase)
      if u.may_confirm?(params[:token])
        u.confirm!(params[:token])
        respond_to do |format|
          format.json { head :ok }
        end
      else
        respond_to do |format|
          format.json { render json: { errors: "Invalid confirmation token" }, status: :unprocessable_entity }
        end
      end
    end

    def sign_in
      u = User.find_by(email: sign_in_params[:email])
      if u && u.confirmed? && u.authenticate(sign_in_params[:password])
        if token = u.authentication_tokens.expired.first
          token.refresh!
        else
          AuthenticationToken.create!(user: u) if u.authentication_tokens.empty?
          token = u.authentication_tokens.fresh.first
        end
        token.use!
        respond_to do |format|
          format.json { render json: { token: token.token }, status: :ok }
        end
      else
        respond_to do |format|
          format.json { render json: { errors: "User's email unconfirmed" }, status: :unprocessable_entity }
        end
      end
    end

    def show
      respond_to do |format|
        format.json {
          render json: {
            email: @user.email,
            first_name: @user.first_name,
            last_name: @user.last_name,
            confirmed: @user.confirmed?
          }, status: :ok
        }
      end
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
