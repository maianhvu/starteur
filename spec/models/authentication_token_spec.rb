require 'rails_helper'

RSpec.describe AuthenticationToken, type: :model do

  let!(:token) { FactoryGirl.create(:authentication_token) }
  AuthenticationToken.aasm.states.each do |s|
    let!("#{s.to_s}_token".to_sym) { FactoryGirl.create("#{s.to_s}_auth_token".to_sym) }
  end

  # Token auto-generation
  it 'should auto-generate upon initialization' do
    t = token.reload.token
    expect(t).not_to be_nil
    expect(t.length).to be(64)
  end

  # AASM
  context 'Finite States Machine' do

    it 'should default to fresh state' do
      expect(token.state).to eq('fresh')
    end

    it 'may transition from fresh and in_use to in_use' do
      expect(fresh_token.may_use?).to be_truthy
      expect(in_use_token.may_use?).to be_truthy
    end

    it 'may transition from fresh and in_use to expired' do
      expect(fresh_token.may_expire?).to be_truthy
      expect(in_use_token.may_expire?).to be_truthy
    end

    it 'may transition from expired back to fresh' do
      expect(expired_token.may_refresh?).to be_truthy
    end

    it 'should generate a new code when refreshed' do
      t = expired_token
      original_token = t.token
      expect { t.refresh! }.to_not raise_error
      expect(t).to be_fresh
      expect(t.token).to_not eq(original_token)
      expect(t.expires_at).to be_within(3.weeks).of(Time.now)
    end
  end
end
