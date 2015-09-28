require 'rails_helper'

RSpec.describe User, type: :model do

  context 'Validations' do
    # email
    it 'should have an email address' do
      expect(build(:user, email: ' '*5)).to_not be_valid
    end

    it 'should have an unique email address' do
      attrib = attributes_for(:user)
      User.create!(attrib)
      expect(User.new(attrib)).to_not be_valid
    end

    # first_name and last_name
    it 'should have names' do
      expect(build(:user, first_name: nil)).to_not be_valid
      expect(build(:user, last_name: nil)).to_not be_valid
    end

    it 'should titleize names' do
      user1 = attributes_for(:user)
      user2 = create(:user_with_downcased_names)
      expect(user2.reload.first_name).to eq(user1[:first_name])
      expect(user2.reload.last_name).to eq(user1[:last_name])
    end

    it 'should trim names' do
      user = build(:user)
      user.first_name = "   #{user.first_name}      "
      user.last_name = "   #{user.last_name}      "
      user.save!
      expect(user.reload.first_name).to eq(user.reload.first_name.strip)
      expect(user.reload.last_name).to eq(user.reload.last_name.strip)
    end

    it 'should have confirmation token upon registration' do
      user = create(:user)
      expect(user.confirmation_token).to_not be_nil
    end
  end

  # tests for finite states machine
  context 'Finite States Machine' do

    let!(:user) { FactoryGirl.create(:user) }
    let(:conf_token) { user.confirmation_token }

    it 'should default to registered' do
      expect(user.state).to eq('registered')
    end

    it 'may transition from registered to confirmed' do
      expect(user.may_confirm?(conf_token)).to be_truthy
    end

    it 'may transition from (registered or confirmed) to deactivated' do
      expect(user.may_deactivate?).to be_truthy
      expect(FactoryGirl.create(:confirmed_user).may_deactivate?).to be_truthy
    end
  end

  context 'Registration and Confirmation' do

    let!(:user)      { FactoryGirl.create(:user) }
    let!(:conf_token) { user.confirmation_token }
    let (:false_token) {
      while true
        token = SecureRandom.hex(32)
        break token unless token.equal?(conf_token)
      end
    }

    it 'should have a trimmed and downcased email' do
      user2 = FactoryGirl.create(:user_with_bloated_email)
      expect(user2.reload.email).to eq(user2.email.strip.downcase)
    end

    it 'should have a confirmation token created' do
      expect(conf_token).not_to be_nil
      expect(conf_token).not_to be_empty
      expect(conf_token.length).to be(64)
    end

    it 'should confirm valid confirmation token' do
      expect(user.may_confirm?(conf_token)).to be_truthy
      user.confirm(conf_token)
      expect(user).to be_confirmed
    end

    it 'should set confirmed_at upon confirmation' do
      user.confirm(conf_token)
      expect(user.confirmed_at).not_to be_nil
      expect(user.confirmed_at).to be_within(10.seconds).of(Time.now)
    end

    it 'should NOT confirm invalid confirmation token' do
      expect(user.may_confirm?(false_token)).to be_falsy
      expect{ user.confirm(false_token) }.to raise_error(AASM::InvalidTransition)
    end

    it 'should NOT set confirmed_at upon failed confirmation' do
      expect { user.confirm(false_token) }.to raise_error(AASM::InvalidTransition)
      expect(user.confirmed_at).to be_nil
    end

    it 'should generate an authentication token upon successful confirmation' do
      expect {
        user.confirm(conf_token)
      }.to change{ user.authentication_tokens.count }.by(1)
    end

    it 'should NOT generate an authentication token upon failed confirmation' do
      expect {
        expect { user.confirm(false_token) }.to raise_error(AASM::InvalidTransition)
      }.not_to change { user.authentication_tokens.count }
    end
  end

end
