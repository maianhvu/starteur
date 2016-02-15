class BillingForm
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  attr_accessor :line_items, :discount_code, :billing_record, :errors

  def initialize(billable, params = {})
    @errors = []
    # raise params.inspect
    @line_items = {}
    @billing_record ||= BillingRecord.new(billable: billable)
    params[:test_ids].each do |test_id|
      test = Test.find(test_id)
      quantity = params[:lineitems][test_id][:quantity].to_i
      if test && quantity > 0
        bli = BillingLineItem.new(billing_record: @billing_record, test: test, quantity: quantity)
        @line_items[test] = quantity
      end
    end
    @discount_code = DiscountCode.find_by(code: discount_code)
    if @discount_code && !@discount_code.billing_record
      @billing_record.discount_code = @discount_code
    end
  end

  def save
    unless @billing_record.save
      @errors = @billing_record.errors.full_messages.join(', ')
    end
    @errors.empty?
  end

  def calculate_total
    total = @line_items.inject(0) { |a, e| a + e.first.price * e.last }
    if discount_code
      total = total * (100 - discount_code.percentage) / 100
    end
    total
  end
end
