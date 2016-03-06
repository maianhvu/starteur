FactoryGirl.define do

  factory :question do
    sequence(:ordinal, 1)
    sequence(:content) { |n| "Question ##{n}" }
    choices ["A little bit", "So so only", "OMG Awesome"]
    polarity 1
    scale 7

    trait :reversed do
      polarity(-1)
    end

    trait :yes_no do
      choices ["Yes", "No"]
    end
  end

end
