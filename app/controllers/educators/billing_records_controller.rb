class Educators::BillingRecordsController < Educators::BaseController

  def index
    @billing_records = BillingRecord.where(billable_id: @educator.id)
  end

  def new
    # raise params.inspect
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
    @dc = DiscountCode.find_by(code: params[:code])

    # @billing_form = BillingForm.new(@educator, params)
  end

  def display_tests
    @tests = Test.all
    @choices = nil
    if params[:choices] != nil
      @choices = params[:choices]
    end
  end

  def create
    dc = DiscountCode.find_by(code: params[:code])
    lineitems = params[:lineitems]
    current_time = Time.now.to_formatted_s(:number)
    educator_id = @educator.id.to_s
    bill_number = current_time + "_" + educator_id
    record = BillingRecord.create(bill_number: bill_number, billable: @educator, discount_code: dc)
    total_quantity = Hash.new

    lineitems.each_pair do |test_id, quantity|
      BillingLineItem.create(test: Test.find(test_id), quantity: quantity, billing_record: record)
      total_quantity[Test.find(test_id).name] = quantity
    end
    if record.save
      lineitems.each_pair do |test_id, quantity|
        AccessCode.create!(code: bill_number + test_id, educator: @educator, test: Test.find(test_id), permits: quantity)
      end

      flash[:success] = "Successfully bought access codes"
      flash[:summary] = total_quantity
      redirect_to purchase_success_educators_billing_records_path
    else
      flash[:error] = "Unable to purchase access codes"
      redirect_to display_tests_educators_billing_records_path()
    end

    # raise params.inspect
    # @billing_form = BillingForm.new(@educator, billing_params)
    # if @billing_form.save
    #   flash[:success] = "Successfully bought access codes"
    #   redirect_to purchase_success_educators_billing_records_path
    # else
    #   flash[:error] = "Unable to purchase access codes"
    #   redirect_to display_tests_educators_billing_records_path
    # end
  end

  def show
    @billing_record = BillingRecord.find(params[:id])
    @bill_number = @billing_record.bill_number
    @created_at = @billing_record.created_at
    @billing_details = BillingLineItem.where(billing_record_id: @billing_record.id)
    @dc = @billing_record.discount_code
  end

  def purchase_confirmation

  end

  def apply_discount
    # raise params.inspect
    # @billing_form = BillingForm.new(@educator, params)
    ret_hash = {}
    @lineitems = {}
    params[:lineitems].each do |k, v|
      test = Test.find(k)
      @lineitems[k] = {quantity: v, price: test.price, name: test.name}
    end
    ret_hash[:lineitems] = @lineitems
    ret_hash[:test_ids] = @lineitems.keys
    # raise @lineitems.inspect
    @dc = DiscountCode.find_by(code: params[:code])
    if @dc && @dc.billing_record.nil?
      ret_hash[:code] = @dc.code
      flash.now[:success] = 'Discount applied successfully'
    else
      @dc = nil
      flash.now[:error] = 'Invalid discount code'
    end

    redirect_to new_educators_billing_record_path(params: ret_hash)
  end
end
