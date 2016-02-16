class Educators::CoeducatorsController < Educators::BaseController

  before_action :prepare_batch
  before_action :prepare_new_coeducator, only: [:create]
  before_action :prepare_remove_coeducator, only: [:destroy]

  def index
    @coeducators = @batch.coeducators
  end

  def create
    if @coeducator
      if (@batch.coeducators.include?(@coeducator) || @batch.educator == @coeducator)
        flash[:notice] = 'Educator is already either an educator or coeducator of this batch'
      else
        @batch.coeducators << @coeducator
        flash[:notice] = 'Successfully added coeducator'
      end
    else
      flash[:error] = 'Educator does not exist'
    end
    redirect_to educators_batch_coeducators_path(@batch)
  end

  def destroy
    if @batch.coeducators.destroy(@coeducator)
      flash[:notice] = 'Successfully removed coeducator'
    else
      flash[:error] = @coeducator.errors
    end
    redirect_to educators_batch_coeducators_path(@batch)
  end

  private
  def prepare_batch
    @batch = Batch.find(params[:batch_id])
  end

  def prepare_new_coeducator
    @coeducator = Educator.find_by(email: params[:batch_users][:email])
  end

  def prepare_remove_coeducator
    @coeducator = Educator.find(params[:id])
  end
end
