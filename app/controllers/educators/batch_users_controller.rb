class Educators::BatchUsersController < Educators::BaseController

  skip_before_filter :require_login, only: [:allow_access]

  def create
    @email = params[:batch_users][:email]
    if @email == ""
      flash[:alert] = "Please enter the user's email address"
      redirect_to controller: "batches", action: "show", id: params[:batch_users][:batch_id]
    else
      @first_name = params[:batch_users][:first_name]
      @last_name = params[:batch_users][:last_name]

      @batch = Batch.find(params[:batch_users][:batch_id])

      list = @batch.email
      if list.include?(@email)
        flash[:alert ] = "The e-mail you entered already exists!"
      else
        list.push(@email)
        @batch.save
        flash[:notice ] = "Email has been added!"
      end
      redirect_to educators_batch_path(@batch)
    end
  end

  def destroy
    batch = Batch.find(params[:id])
    email_list = batch.email
    email_list.delete(params[:email])
    cu = batch.code_usages.find_by(email: params[:email])
    bcu = batch.batch_code_usages.find_by(batch: batch, code_usage: cu)
    if bcu
      bcu.destroy
    end
    if cu && cu.user.nil?
      cu.destroy
    end
    batch.save
    flash[:alert ] = "Email has been deleted!"
    redirect_to controller: "batches", action: "show", id: params[:id]
  end

  def read
    @batch = Batch.find(params[:batch_users][:batch_id])
    list = @batch.email

    uploaded_io = params[:batch_users][:file]
    if uploaded_io
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
    else
      flash[:alert] = "Please choose the correct CSV file"
    end
    redirect_to controller: "batches", action: "show", id: params[:batch_users][:batch_id]
  end

  def allow_access
    batch = Batch.find(params[:batch_id])
    user = User.find_by(email: params[:email])
    if batch && user
      cu = CodeUsage.find_by(user: user, access_code: user.access_codes.where(test: batch.test))
      BatchCodeUsage.create(batch: batch, code_usage: cu)
      flash[:success] = 'Permission granted'
    else
      flash[:error] = 'Invalid parameters'
    end
    redirect_to root_path
  end

end
