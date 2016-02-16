FactoryGirl.define do
  factory :test do
    name 'Starteur Profiling Assessment'
    description "This is a Starteur test"
    state Test.states[:published]
    price 10.0
    shuffle false
    sequence(:processor_file) { |n| "test_processor#{n}" }

    trait :unpublished do
      state Test.states[:unpublished]
    end

    trait :shuffle do
      shuffle true
    end

    trait :generic do
      sequence(:name) { |n| "Test Number #{n}" }
    end

    trait :full do
      after(:create) do |test|
        create_list(:category, 3, :full, test_id: test.id)
      end
    end

  end
end
