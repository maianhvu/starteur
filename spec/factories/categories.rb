FactoryGirl.define do

  factory :category do
    rank 1
    sequence(:title) { |n| "Category ##{n}" }
    description "Just another category"
    sequence(:symbol) { |n| "C#{n}" }

    trait :full do
      after(:create) do |category|
        create_list(:question, 3, category_id: category.id, test_id: category.test_id)
        create_list(:question, 2, :yes_no, category_id: category.id, test_id: category.test_id)
      end
    end
  end

end
