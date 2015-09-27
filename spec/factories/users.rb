require 'faker'

FactoryGirl.define do
  factory :user do

    transient do
      email_addr Faker::Internet.email
      f_name Faker::Name.first_name
      l_name Faker::Name.last_name
    end
    email      { "#{email_addr}" }
    password   { Faker::Internet.password(8) }
    first_name { "#{f_name}" }
    last_name  { "#{l_name}" }
    confirmation_token { SecureRandom.hex(32) }

    factory :user_with_bloated_email do
      email { "   #{email_addr.upcase}     " }
    end

    factory :user_with_downcased_names do
      first_name { "#{f_name.upcase}" }
      last_name  { "#{l_name.upcase}" }
    end

    # For AASM
    User.states.each_key do |s|
      trait s do
        state s
      end
      factory "#{s.to_s}_user".to_sym, traits: [s]
    end

  end
end
