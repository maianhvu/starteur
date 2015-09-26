module API
  class UsersController < ApplicationController

    def create
      u = User.create(register_params)
      if u.save
        respond_to do |format|
          format.json { head :created }
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
        u.confirm(params[:token])
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

    private

    def register_params
      params.require(:user).permit(:email, :password, :first_name, :last_name, :type)
    end

    def sign_in_params
      params.require(:user).permit(:email, :password)
    end

  end
end
