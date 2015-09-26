FactoryGirl.define do
  factory :authentication_token do
    user { FactoryGirl.build_stubbed(:user) }

    AuthenticationToken.aasm.states.each do |s|
      factory "#{s.to_s}_auth_token".to_sym do
        state s
      end
    end
  end

end
