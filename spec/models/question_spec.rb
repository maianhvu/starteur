require 'rails_helper'

RSpec.describe Question, type: :model do

  # Validations
  context 'Validations' do
    it 'should have an integer ordinal' do
      q = FactoryGirl.build(:question)
      expect(q).to be_valid
      q.ordinal = "hello!"
      expect(q).to_not be_valid
      q.ordinal = 1.1
      expect(q).to_not be_valid
    end

    it 'should have unique ordinals' do
      q = FactoryGirl.create(:question)
      expect(Question.new(ordinal: q.ordinal)).to_not be_valid
    end
  end
end
