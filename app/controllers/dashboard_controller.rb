class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard'

  def index
    # if test = Test.published.where('name ILIKE %Starteur Profiling Assessment%')
    if test = Test.published.last
      @test_id = test.id
    else
      # FIXME: Potential buggy/exploitable
      @test_id = 1
    end
  end
end
