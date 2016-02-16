FactoryGirl.define do
  factory :access_code do
    sequence(:code) { |n| "sXdROhpKsQ6hwAZ#{n}" }
  end
end
