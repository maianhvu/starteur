class Educators::BatchUsersController < Educators::BaseController

  def create
    @email = params[:batch_users][:email]
    @first_name = params[:batch_users][:first_name]
    @last_name = params[:batch_users][:last_name]

    @batch = Batch.find(params[:batch_users][:batch_id])

    list = @batch.email
    if list.include?(@email)
      flash[:alert ] = "The e-mail you entered already exists!"
      redirect_to controller: "batches", action: "show", id: params[:batch_users][:batch_id]
    else
      list.push(@email)
      @batch.save
      flash[:notice ] = "Email has been added!"
      redirect_to controller: "batches", action: "show", id: params[:batch_users][:batch_id]
    end
  end

  def destroy
  	batch = Batch.find(params[:id])
    email_list = batch.email
    email_list.delete(params[:email])
    puts email_list
    batch.save
    flash[:alert ] = "Email has been deleted!"
    redirect_to controller: "batches", action: "show", id: params[:id]
  end

  def read
  	@batch = Batch.find(params[:batch_users][:batch_id])
  	list = @batch.email

  	uploaded_io = params[:batch_users][:file]
  	path = uploaded_io.path

  	CSV.foreach(path) do |row|
  		@email = row.first
  		if list.include?(@email)
	      flash[:alert ] = "The e-mail #{@email} you entered already exists!"
	    else
	      list.push(@email)
	      @batch.save
	      flash[:notice ] = "Uploaded CSV file"
	    end
  	end
  	redirect_to controller: "batches", action: "show", id: params[:batch_users][:batch_id]
  end

  def assign
    acs = Educators::AssignAccessCodeService.new({ac:AccessCode.all,email:params[:email],users:User.all,educator:@educator,test_id:params[:test],batch_id:params[:id]})
    acs.assign_code ? flash[:notice ] = "Code assigned" : flash[:notice ] = "Insufficient number of codes"
    redirect_to controller: "batches", action: "show", id: params[:id]
  end

  def assignall
    batch = Batch.find(params[:batch])
    acs = Educators::AssignAccessCodeService.new({ac:AccessCode.all, users:User.all, educator:@educator, test_id:params[:test], batch_id:batch.id})
    acs.assign_to_all ? flash[:notice ] = "Codes assigned" : flash[:notice ] = "Insufficient number of codes"
    redirect_to controller: "batches", action: "show", id: params[:batch]
  end
end