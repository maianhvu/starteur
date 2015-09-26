require 'rails_helper'

RSpec.describe Test, type: :model do

  context 'Validations' do
    it 'must have a name' do
      expect(FactoryGirl.build(:test_without_name)).to_not be_valid
    end

    it 'must have a unique name' do
      test = FactoryGirl.create(:test)
      expect(FactoryGirl.build(:test)).to_not be_valid
    end

    it 'should default to free (price)' do
      test = FactoryGirl.create(:test_without_price)
      expect(test.reload.price).to eq(0.0)
    end
  end

  context 'Finite States Machine' do
    it 'should default to unpublished' do
      expect(FactoryGirl.build(:test).state).to eq('unpublished')
    end

    it 'may transition from unpublished to published' do
      expect(FactoryGirl.build(:unpublished_test).may_publish?).to be_truthy
    end

    it 'may transition from published back to unpublished' do
      expect(FactoryGirl.build(:published_test).may_unpublish?).to be_truthy
    end

    it 'may transition from unpublished and published to deleted' do
      ['unpublished', 'published'].each do |state|
        expect(FactoryGirl.build("#{state}_test".to_sym).may_delete?).to be_truthy
      end
    end

    it 'may transition from deleted back to unpublished' do
      expect(FactoryGirl.build(:deleted_test).may_recover?).to be_truthy
    end
  end
end
