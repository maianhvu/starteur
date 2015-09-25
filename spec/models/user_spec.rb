require 'rails_helper'

RSpec.describe User, type: :model do

  # tests for presence
  context 'should be invalid without required params' do
    # email
    it 'should have an email address' do
      expect(build(:user_without_email)).to_not be_valid
    end

    it 'should have names' do
      expect(build(:user_without_first_name)).to_not be_valid
      expect(build(:user_without_last_name)).to_not be_valid
    end
  end

end
