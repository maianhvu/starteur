class PagesController < ApplicationController
  def index
    @user = User.new
  end

  def registration_successful
    render 'registration_successful', layout: 'dashboard'
  end
end
