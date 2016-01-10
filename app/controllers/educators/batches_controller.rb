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
      redirect_to educators_educator_path(@educator)
    else
      flash[:notice ] = "Please enter Batch Name"
      redirect_to educators_educator_path(@educator)
    end
  end

  def show
    if (params[:id]) 
      @batch = Batch.find(params[:id])
      @remaining_access_codes = AccessCode.where(educator_id: @educator.id, test_id: @batch.test.id).count
    else  
      @batch = Batch.find(params[:upload_csv][:batch_id])
      @remaining_access_codes = AccessCode.where(educator_id: @educator.id, test_id: @batch.test.id).count
      @list = @email_list.all
    end

    # code to count number of students in different state. Commented out for now.
    #@total_students = @batch.email.count
    #@students_not_accepted = 0
    #@students_in_progress = 0
    #@students_completed = 0

    #@users = []
    #@batch.email.each do |mail|
    #  @users << User.find_by(email: mail)
    #end

    #@users.each do |user|
    #  if user.state == 1
    #    @students_not_accepted += 1
    #  elsif user.state == 8
    #    @students_in_progress += 1
    #  end
    #end
  end

  def destroy
    Batch.find(params[:id]).destroy
    flash[:alert ] = "Batch Deleted"
    redirect_to educators_educator_path(@educator)
  end

  def add_batch
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def educator_params
    params.require(:educator).permit(:email, :password)
  end

end