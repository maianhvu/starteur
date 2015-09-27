require 'rails_helper'

RSpec.describe Answer, type: :model do

  # Validations
  context 'Validations' do

    it 'should have a user and a choice' do
      expect(FactoryGirl.build(:answer, :user => nil)).to_not be_valid
      expect(FactoryGirl.build(:answer, :choice => nil)).to_not be_valid
    end

    it 'should be unique to a user within a question' do
      test = FactoryGirl.create(:faked_test)
      user = FactoryGirl.create(:confirmed_user)
      question = FactoryGirl.create(:question)
      choices = []
      2.times do
        choice = FactoryGirl.build(:choice)
        choice.question = question
        choice.save!
        choices << choice
      end

      Answer.create!(choice: choices[0], user: user, test: test)
      expect(Answer.new(choice: choices[1], user: user, test: test)).to_not be_valid
    end
  end
end
