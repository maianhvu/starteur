require 'faker'

FactoryGirl.define do
  factory :category do
    rank 1
    title       { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    test        { FactoryGirl.create(:faked_test) }
  end

end
