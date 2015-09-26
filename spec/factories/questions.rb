FactoryGirl.define do
  factory :question do
    sequence(:ordinal, 1)
    content { Faker::Hacker.say_something_smart }
  end

end
