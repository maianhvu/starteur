FactoryGirl.define do
  factory :user do
    email 'me@maianhvu.com'
    first_name 'Anh Vu'
    last_name 'Mai'
    password 'secretpassword'
    type 'UserMember'

    confirmation_token 'ePKeQiyKMztHfR77q3V7'
    confirmed_at nil # unconfirmed
    confirmation_sent_at { 3.weeks.ago }

    deactivated false
    state User.states[:registered]

    trait :confirmed do
      confirmed_at { 1.day.ago }
      state User.states[:confirmed]
    end

    trait :generic do
      sequence(:email) { |n| "user#{n}@example.com" }
    end

  end
end
