class Educators::BatchesController < Educators::BaseController

  def index
    if Batch.all.blank?
      flash[:notice ] = "You have no batches. Please create one."
      render "new"
    else
      @batches = @educator.batches
      @test = Test.all
      @edu = @educator.email
    end
  end

  def new
  end

  def create
    @test_id = Test.find(params[:batch][:test_id])
    @batchname = params[:batch][:batch_name]
    @batch = Batch.new(educator: @educator, test: Test.find_by(id: @test_id), name: @batchname)
    if @batch.save
      flash[:notice ] = "Batch Created"
      redirect_to educators_batches_path
    end
  end

  def show
    if (params[:id]) 
      @batch = Batch.find(params[:id])
      @codeusage = {}
      @batch.email.each do |e|
        cu = CodeUsage.find_by(email: e)
        if cu.blank?
          
        else
          @codeusage[e] = cu
        end
      end
    else  
      @batch = Batch.find(params[:upload_csv][:batch_id])
      @list = @email_list.all
    end
  end

  def destroy
    Batch.find(params[:id]).destroy
    flash[:alert ] = "Batch Deleted"
    redirect_to educators_batches_path
  end

  private

  def educator_params
    params.require(:educator).permit(:email, :password)
  end

end