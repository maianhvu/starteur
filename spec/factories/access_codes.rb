require 'faker'

FactoryGirl.define do
  factory :access_code do
    code { Faker::Bitcoin.address }
    test { FactoryGirl.build_stubbed(:faked_test) }
    last_used_at { 10.minutes.ago }
    permits 1

    trait :universal do
      permits -1
    end

    factory :universal_access_code, traits: [ :universal ]
  end

end
