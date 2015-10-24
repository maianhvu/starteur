require 'rails_helper'

RSpec.describe Educator, type: :model do

  it { is_expected.to have_many(:access_codes) }
  it { is_expected.to have_many(:batches) }
  it { is_expected.to have_many(:billing_records) }

  it { is_expected.to validate_presence_of(:email) }

end
