class Educators::EducatorsController < Educators::BaseController

  skip_before_action :require_login, only: [:new, :create]
  skip_before_action :prepare_educator, only: [:index, :new, :create]

  def index
  end

  def new
    @educator = Educator.new
  end

  def create
    @educator = Educator.new(educator_params)

    if @educator.save
      redirect_to educators_login_path, notice: 'Account successfully created'
    else
      flash.now[:error] = @educator.errors.full_messages.join(", ")
      render :new
    end
  end

  def show
    # @batches: All of Batches belong to this Educator
    @batches = @educator.batches
    @cobatches = @educator.cobatches

    # @purchased_tests: All of Tests belong to this Educator
    @access_codes = AccessCode.where(educator_id: @educator.id)
    @purchased_tests = []
    @access_codes.each do |access_code|
      if !@purchased_tests.include? access_code.test
        @purchased_tests << access_code.test
      end
    end

    # @remaining_access_codes: List of Tests and its remaining number of access codes belong to this Educator
    @remaining_access_codes = Hash.new

    @tests_with_access_codes = Hash.new
    @test_with_code_usages = Hash.new

    @access_codes.each do |access_code|
      if @tests_with_access_codes[access_code.test] == nil
        @tests_with_access_codes[access_code.test] = [access_code]
      else
        @tests_with_access_codes[access_code.test] << access_code
      end
    end

    @tests_with_access_codes.each do |test, access_code_list|
      total_permits = 0
      num_code_usages = 0
      num_code_usages_remaining = 0
      access_code_list.each do |access_code|
        total_permits = total_permits + access_code.permits
        num_code_usages = num_code_usages + access_code.code_usages.size
      end
      num_code_usages_remaining = total_permits - num_code_usages
      @remaining_access_codes[test] = num_code_usages_remaining
    end
  end

  def edit
  end

  def update
    if @educator.update_attributes(update_educator_params)
      redirect_to educators_educator_path(@educator), notice: "Update successful"
    else
      render :edit
    end
  end

  private

  def educator_params
    params.require(:educator).permit(:email, :password, :password_confirmation)
  end

  def update_educator_params
    params.require(:educator).permit(:first_name, :last_name, :organization, :title, :secondary_email)
  end

end
