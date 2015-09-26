FactoryGirl.define do
  factory :authentication_token do
    user { FactoryGirl.build_stubbed(:user) }

    AuthenticationToken.aasm.states.each do |s|
      trait s do
        state s
      end
      factory "#{s.to_s}_auth_token".to_sym, traits: [s]
    end
  end

end
