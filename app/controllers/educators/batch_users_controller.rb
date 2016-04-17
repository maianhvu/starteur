require 'prawn'
require 'valid_email'
class Educators::BatchUsersController < Educators::BaseController

  skip_before_filter :require_login, only: [:allow_access]

  def create
    @email = params[:batch_users][:email]
    @first_name = params[:batch_users][:first_name]
    @last_name = params[:batch_users][:last_name]

    @batch = Batch.find(params[:batch_users][:batch_id])

    hlist = @batch.username

    list = @batch.email

    valid = ValidateEmail.valid?(@email)
    if valid
      if list.include?(@email)
        flash[:alert ] = "The e-mail you entered already exists!"
        redirect_to controller: "batches", action: "show", id: params[:batch_users][:batch_id]
      else
        hlist[@email] = [@last_name, @first_name]
        list.push(@email)
        @batch.save
        flash[:notice ] = "Email has been added!"
        redirect_to controller: "batches", action: "show", id: params[:batch_users][:batch_id]
      end
    else
      flash[:alert] = "#{@email} is invalid"
      redirect_to controller: "batches", action: "show", id: params[:batch_users][:batch_id]
    end
  end

  def destroy
    batch = Batch.find(params[:id])
    email_list = batch.email
    puts params[:email]
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
    hlist = @batch.username

    uploaded_io = params[:batch_users][:file]
    path = uploaded_io.path

    # Validate email
    emails = []

    CSV.foreach(path, col_sep: ',',:row_sep => :auto, skip_blanks: true) do |unstripped_row|
      emails << unstripped_row[0].to_s.strip
    end
    
    invalid_emails = []
    emails.each do |email|
      begin
        valid = ValidateEmail.valid?(email)
      rescue
        valid = false
      end
      unless valid
        invalid_emails << email
      end
    end

    if invalid_emails.length > 0
      flash[:alert] = "CSV file contains invalid emails (#{invalid_emails.join(', ')})"
    else
      CSV.foreach(path, col_sep: ',', skip_blanks: true) do |unstripped_row|
        @email = unstripped_row[0].to_s.strip
        @last_name = unstripped_row[1].to_s.strip
        @first_name = unstripped_row[2].to_s.strip

        if list.include?(@email)
          flash[:alert ] = "The e-mail #{@email} you entered already exists!"
        else
          hlist[@email] = [@last_name, @first_name]
          list.push(@email)
          @batch.save
          flash[:notice ] = "Uploaded CSV file"
        end
      end
    end
    redirect_to controller: "batches", action: "show", id: params[:batch_users][:batch_id]
  end

  def allow_access
    batch = Batch.find(params[:batch_id])
    user = User.find_by(email: params[:email])
    if batch && user
      cu = CodeUsage.find_by(user: user, access_code: user.access_codes.where(test: batch.test))
      bcu = BatchCodeUsage.find_by(batch: batch, code_usage: cu)
      bcu.update(own: true)
      flash[:success] = 'Permission granted'
    else
      flash[:error] = 'Invalid parameters'
    end
    redirect_to root_path
  end

  def generate_report
    pdf = Educators::ReportPdfService.new(batch_id: params[:batch_id], user_id: params[:user_id])
    send_data pdf.render, filename: 'report.pdf', type: 'application/pdf'
  end

  def generate_batch_report
    pdf = Educators::BatchReportPdfService.new(batch_id: params[:batch_id])
    send_data pdf.render, filename: 'batch_report.pdf', type: 'application/pdf'
  end
end