require 'faker'

FactoryGirl.define do
  factory :choice do
    content { Faker::Hacker.adjective }
    sequence(:points, 1)
    ordinal nil

    factory :ordered do
      sequence(:ordinal, 1)
    end

    factory :choice_without_content do
      content " "*5
    end

    factory :choice_without_points do
      points nil
    end
  end

end
