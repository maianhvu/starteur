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
    all_ac = AccessCode.all
    email = params[:email]
    users = User.all
    user = nil
    codeusage = nil
    list = []
    sum = 0 
    all_ac.each do |ac|
      if ac.educator_id == @educator.id && ac.test.id == params[:test].to_i
        list.push(ac)
        sum += ac.permits
      end
    end
    
    users.blank? ? "": users.each{|u| u.email == email ? user = u : ""}

    list.each do |ac|
      if ac.permits-ac.code_usages.size > 0
        if user.blank?
          codeusage = CodeUsage.new(access_code: ac, state: 1, batch_id: params[:id], email: email)
          codeusage.save; return if performed?
          flash[:notice ] = "Code Assigned"
        else
          codeusage = CodeUsage.new(access_code: ac, user_id: user.id, state: 1, batch_id: params[:id], email: email)
          codeusage.save; return if performed?
          flash[:notice ] = "Code Assigned"
        end
      end
    end
    redirect_to controller: "batches", action: "show", id: params[:id]
  end

  def assignall
    all_ac = AccessCode.all
    users = User.all
    user = nil
    list = []
    sum = 0 
    all_ac.each do |ac|
      if ac.educator_id == @educator.id && ac.test.id == params[:test].to_i
        list.push(ac)
        sum = ac.permits - ac.code_usages.size
      end
    end

    batch = Batch.find(params[:batch])
    email_list = batch.email
    num = email_list.count

    email_list.each {|el| CodeUsage.exists?(email: el, batch_id: batch.id) ? num -= 1 : ""}

    testnumber = 0
    if sum >= num
      email_list.each do |el|
        list.each do |ac|
          if ac.permits-ac.code_usages.size > 0
            users.blank? ? "": users.each{|u| u.email == el ? user = u : ""}
            if user.blank?
              unless CodeUsage.exists?(email: el, batch_id: batch.id) 
                codeusage = CodeUsage.new(access_code: ac, state: 1, batch_id: batch.id, email: el)
                codeusage.save; return if performed?
              end
            else
              codeusage = CodeUsage.new(access_code: ac, user_id: user.id, state: 1, batch_id: batch.id, email: el)
              codeusage.save; return if performed?
            end
          end
        end
      end
      flash[:notice ] = "Code Assigned"
    else
      flash[:alert ] = "Not enough access codes"
    end
    redirect_to controller: "batches", action: "show", id: params[:batch]
  end
end