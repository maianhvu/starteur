require 'rails_helper'

RSpec.describe Answer, type: :model do

  # Validations
  context 'Validations' do

    it 'should have a user and a question' do
      expect(FactoryGirl.build(:answer, :user => nil)).to_not be_valid
      expect(FactoryGirl.build(:answer, :question => nil)).to_not be_valid
    end

    it 'should be unique to a user within a question' do
      test = FactoryGirl.create(:faked_test)
      user = FactoryGirl.create(:confirmed_user)
      question = FactoryGirl.create(:question)

      Answer.create!(question: question, user: user, test: test, value: 4)
      expect(Answer.new(question: question, user: user, test: test, value: 3)).to_not be_valid
    end

    it 'must have a value' do
      expect(FactoryGirl.build(:answer, value: nil)).to_not be_valid
    end
  end
end
