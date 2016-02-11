FactoryGirl.define do

  factory :category do
    rank 1
    sequence(:title) { |n| "Category ##{n}" }
    description "Just another category"
    sequence(:symbol) { |n| "C#{n}" }

    trait :full do
      after(:build) do |category|
        create_list(:question, 3, category: category)
        create_list(:question, 2, :yes_no, category: category)
      end
    end
  end

end
