module API
  class TestsController < AuthenticatedController
    before_action :authenticate

    def index
      @tests = Test.published.all
      respond_to do |format|
        format.json { render :status => :ok }
      end
    end
  end
end
