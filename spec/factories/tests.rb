FactoryGirl.define do
  factory :test do
    sequence(:name) { |n| "Test Number #{n}" }
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

    # Custom factories
    factory :starteur_profiling_test do
      name 'Starteur Profiling Assessment'
    end

  end
end
