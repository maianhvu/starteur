require 'faker'

FactoryGirl.define do
  factory :access_code do
    code { Faker::Bitcoin.address }
    test { FactoryGirl.build_stubbed(:faked_test) }
    last_used_at { 10.minutes.ago }
    universal false

    trait :universal do
      universal true
    end

    factory :universal_access_code, traits: [ :universal ]
  end

end
