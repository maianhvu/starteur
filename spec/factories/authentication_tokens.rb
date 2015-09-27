FactoryGirl.define do
  factory :authentication_token do
    transient do
      valid_user { FactoryGirl.create(:confirmed_user) }
    end

    user { valid_user }

    AuthenticationToken.states.each_key do |s|
      trait s do
        state s
      end
      factory "#{s.to_s}_auth_token".to_sym, traits: [s]
    end
  end

end
