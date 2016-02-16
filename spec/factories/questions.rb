FactoryGirl.define do

  factory :question do
    sequence(:ordinal, 1)
    sequence(:content) { |n| "Question ##{n}" }
    polarity 1

    trait :reversed do
      polarity(-1)
    end

    trait :yes_no do
      choices ["Yes", "No"]
    end
  end

end
