require 'rails_helper'

RSpec.describe Choice, type: :model do

  # Validations
  context 'Validations' do
    it 'must have content' do
      expect(FactoryGirl.build(:choice_without_content)).to_not be_valid
    end

    it 'must have unique content within a question' do
      q1 = FactoryGirl.create(:question)
      c1 = FactoryGirl.build(:choice)
      c1.question = q1
      c1.save!

      # Same question
      c2 = FactoryGirl.build(:choice)
      c2.content = c1.content
      c2.question = q1
      expect(c2).to_not be_valid

      # Different case
      c2.content.upcase!
      expect(c2).to_not be_valid

      # Different question
      c2.question = FactoryGirl.create(:question)
      expect(c2).to be_valid
    end

    it 'must have points' do
      expect(FactoryGirl.build(:choice_without_points)).to_not be_valid
    end

    it 'must have integer points' do
      choice = FactoryGirl.build(:choice)
      choice.points = "hello"
      expect(choice).to_not be_valid
    end
  end
end
