module API
  class UsersController < ApplicationController

    def index
      head 200
    end

    def create
      u = User.create(register_params)
      if u.save
        respond_to do |format|
          format.json { head 201 }
        end
      else
        respond_to do |format|
          format.json { render json: u.errors.messages, status: :unprocessable_entity }
        end
      end
    end

    private

    def register_params
      params.require(:user).permit(:email, :password, :first_name, :last_name, :type)
    end

  end
end
