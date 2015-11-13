class Educators::AccessCodesController < Educators::BaseController

  def index
    @access_codes = AccessCode.where(educator_id: @educator.id)
    @tests_with_access_codes = Hash.new
    @test_with_code_usages = Hash.new

    @access_codes.each do |access_code|
      if @tests_with_access_codes[access_code.test] == nil
        @tests_with_access_codes[access_code.test] = [access_code]
      else
        @tests_with_access_codes[access_code.test] << access_code
      end
    end

    @tests_with_access_codes.each do|test, access_code_list|
      total_permits = 0
      num_code_usages = 0
      num_code_usages_remaining = 0
      access_code_list.each do |access_code|
        total_permits = total_permits + access_code.permits
        num_code_usages = num_code_usages + access_code.code_usages.size
      end
      num_code_usages_remaining = total_permits - num_code_usages
      @test_with_code_usages[test] = [total_permits, num_code_usages, num_code_usages_remaining]
    end
  end
  
  def show
    @test = params[:id]
    @access_codes = AccessCode.where(educator_id: @educator.id)
    @access_codes_for_test = @access_codes.select {|access_code| access_code.test.id == @test.to_i}
    @access_codes_with_code_usages = Hash.new

    @access_codes_for_test.each do|access_code|
      total_permits = access_code.permits
      num_code_usages = access_code.code_usages.size
      num_code_usages_remaining = total_permits - num_code_usages
      @access_codes_with_code_usages[access_code] = [total_permits, num_code_usages, num_code_usages_remaining]
    end
  end

  def new
    @new = AccessCode.new
  end

  def create
  end

  def update
  end

end