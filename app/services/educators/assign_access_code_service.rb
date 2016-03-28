class Educators::AssignAccessCodeService
  def initialize(params)
    # All Access Codes
    @all_ac = params[:ac]

    # Email in the batch. Used for individual assignment
    @email = params[:email]

    # List of all registered users
    @users = params[:users]

    # Current educator
    @educator = params[:educator]

    # Test that is tagged to the batch
    @test_id = params[:test_id]

    # Batch identifier
    @batch_id = params[:batch_id]
  end

  def assign_code
    # Store the total number of permits for all access codes
    sum = 0

    # List of all access codes
    list = []
    @all_ac.each do |ac|
      if ac.educator_id == @educator.id && ac.test.id == @test_id.to_i
        list.push(ac)
        sum += ac.permits - ac.code_usages.size
      end
    end

    # Assign code usage
    user = nil
    if sum > 0
      list.each do |ac|
        @users.each{|u| user = u if u.email == @email} if !@users.blank?
        assign_code_usage(ac, @batch_id, @email, user)
      end
      return true
    else
      return false
    end
  end
  
  def assign_to_all
    # Email list 
    batch = Batch.find_by(id: @batch_id)
    email_list = batch.email
    
    # Store the total number of permits for all access codes
    sum = 0

    # List of all access codes
    list = []
    @all_ac.each do |ac|
      if ac.educator_id == @educator.id && ac.test.id == @test_id.to_i
        list.push(ac)
        sum += ac.permits - ac.code_usages.size
      end
    end

    # Number of assigned codes in the batch
    num = 0
    email_list.each do |email|
      if CodeUsage.exists?(email: email, batch_id: batch.id)
        num += 1
      end
    end

    # Assign code usage
    user = nil
    if sum > email_list.size - num
      email_list.each do |email|
        list.each do |ac|
          @users.each{|u| user = u if u.email == email} if !@users.blank?
          assign_code_usage(ac, batch.id, email, user)
        end
      end
      return true
    else
      return false
    end
  end

  private

  def assign_code_usage(access_code, batch_id, email, user)
    unless CodeUsage.exists?(batch: batch_id, email: email)
      if user.blank?
        CodeUsage.create(access_code: access_code, state: 1, batch_id: batch_id, email: email)
        #call email service to register an account
      else
        CodeUsage.create(access_code: access_code, state: 1, batch_id: batch_id, email: email, user_id: user.id)
        #call email service to access test
      end
    end
  end
end