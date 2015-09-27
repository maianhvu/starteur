require 'faker'

FactoryGirl.define do
  factory :category do
    sequence(:rank, 1)
    sequence :title do |n|
      "Category #{n}"
    end
    description { Faker::Lorem.paragraph }
    test        { FactoryGirl.build_stubbed(:faked_test) }
  end

end
