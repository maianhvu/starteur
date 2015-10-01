require 'faker'

FactoryGirl.define do
  factory :question do
    sequence(:ordinal, 1)
    content { Faker::Hacker.say_something_smart }
    choices {
      cs = []
      3.times do
        cs << Faker::Address.street_name
      end
      cs
    }
    polarity 1
  end

end
