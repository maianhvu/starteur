class PagesController < ApplicationController
  def index
    @user = User.new
  end

  def registration_successful
    render 'registration_successful', layout: 'dashboard'
  end

  def letsencrypt
    render text: 'tCWx18vHA8iemiGxS5aAwhnKTofAlA_TU-7zoIsYLO8.JQsPj9yWgRSqmdJAc0PRGMM9ivp_gENCNn_yIYON2JI'
  end
end
