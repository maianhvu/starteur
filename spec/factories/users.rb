require 'faker'

FactoryGirl.define do
  factory :user do

    transient do
      email_addr Faker::Internet.email
    end
    email      { "#{email_addr}" }
    password   { Faker::Internet.password(8) }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name  }

    # For validations
    factory :user_without_email do
      email (" "*5)
    end

    factory :user_without_first_name do
      first_name nil
    end

    factory :user_without_last_name do
      last_name nil
    end

    factory :user_with_bloated_email do
      email { "   #{email_addr.upcase}     " }
    end

    # For AASM
    User.aasm.states.each do |s|
      trait s do
        state s
      end
      factory "#{s.to_s}_user".to_sym, traits: [s]
    end

  end
end
