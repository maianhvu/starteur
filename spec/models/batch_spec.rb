require 'rails_helper'

RSpec.describe Batch, type: :model do

  it { is_expected.to belong_to(:educator) }
  it { is_expected.to have_many(:code_usages) }
  it { is_expected.to belong_to(:test) }
  it { is_expected.to have_and_belong_to_many(:results) }

  it { is_expected.to validate_presence_of(:educator) }
  it { is_expected.to validate_presence_of(:test) }

end
