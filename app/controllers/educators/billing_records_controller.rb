class Educators::BillingRecordsController < Educators::BaseController

  def index
    @billing_records = BillingRecord.where(billable_id: @educator.id)
  end

  def new
    @checkedtests = params[:test_ids] || {}
    @lineitems = params[:lineitems] || {}  
    @lineitems.select! { |k, v| @checkedtests.include?(k) && v["quantity"].to_i > 0 }  
    if @lineitems.empty? 
      flash[:error] = "Please select a test and indicate the quantity of access codes you want to purchase." 
      redirect_to display_tests_educators_billing_records_path
    end
    test_ids = @lineitems.keys.map(&:to_i)
    Test.where(id: test_ids).each do |test|
      @lineitems[test[:id].to_s][:price] = test[:price].to_i
      @lineitems[test[:id].to_s][:name] = test[:name]      
    end
  end

  def display_tests
    @tests = Test.all
  end

  def create
    lineitems = params[:lineitems]
    current_time = Time.now.to_formatted_s(:number)
    educator_id = @educator.id.to_s
    bill_number = current_time + "_" + educator_id
    record = BillingRecord.create(bill_number: bill_number, billable: @educator)

    lineitems.each_pair do |test_id, quantity|
      BillingLineItem.create(test: Test.find(test_id), quantity: quantity, billing_record: record)
    end
    if record.save
      lineitems.each_pair do |test_id, quantity|
        AccessCode.create!(code: bill_number + test_id, educator: @educator, test: Test.find(test_id), permits: quantity)
      end
      
      flash[:success] = "Successfully bought access codes"
      redirect_to educators_educator_path(@educator)
    else
      flash[:error] = "Unable to purchase access codes"
      redirect_to display_tests_educators_billing_records_path()
    end  
  end 

  def show
    @billing_record = BillingRecord.find(params[:id])
    @bill_number = @billing_record.bill_number
    @created_at = @billing_record.created_at
    @billing_details = BillingLineItem.where(billing_record_id: @billing_record.id)
  end
end
