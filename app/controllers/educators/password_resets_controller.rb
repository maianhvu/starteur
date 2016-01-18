class Educators::PasswordResetsController < Educators::BaseController
  skip_before_filter :require_login

  before_action :prepare_educator_from_token, only: [ :edit, :update ]
  before_action :prepare_passwords, only: [ :update ]

  layout 'educators/simple'

  def new
  end

  def create 
    if (educator = Educator.find_by_email(params[:email]))
      educator.deliver_reset_password_instructions!
      redirect_to educators_root_path, notice: 'Please check your email for further instructions.'
    else
      flash.now[:error] = 'Invalid email address'
      render :new
    end
  end

  def edit
  end

  def update
    if @educator.valid?
      @educator.change_password!(params[:password])
      auto_login(@educator)
      redirect_to educators_educator_path(@educator), notice: 'Password updated successfully'
    else
      flash.now[:error] = 'Passwords entered do not match.'
      render :edit
    end
  end

  private

  def prepare_educator_from_token
    @educator = Educator.load_from_reset_password_token(params[:id])
    not_authenticated if @educator.nil?
  end

  def prepare_passwords
    @educator.password = params[:password]
  end
end
