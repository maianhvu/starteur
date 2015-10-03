class StarteurEd::LoginController < ApplicationController

  def new
    @admin = Administrator.new
  end

  def create
  end
end
