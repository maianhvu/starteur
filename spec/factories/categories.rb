FactoryGirl.define do

  factory :category do
    rank 1
    sequence(:title) { |n| "Category ##{n}" }
    description "Just another category"
    sequence(:symbol) { |n| "C#{n}" }
  end

end
