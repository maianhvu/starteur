class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard'

  def index
    if test = Test.published.where("name ILIKE '%Starteur Profiling Assessment%'").first
    #if test = Test.published.last
      @test_id = test.id
    end
  end
end
