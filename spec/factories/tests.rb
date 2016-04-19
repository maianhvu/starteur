FactoryGirl.define do
  factory :test do
    name 'Starteur Profiling Assessment'
    description 'This is a Starteur test'
    state Test.states[:published]
    price 15.0
    shuffle false
    identifier 'starteur_profiling_assessment'

    trait :unpublished do
      state Test.states[:unpublished]
    end

    trait :shuffle do
      shuffle true
    end

    trait :generic do
      sequence(:name) { |n| "Test Number #{n}" }
      sequence(:identifier) { |n| "test_number_#{n}" }
    end

    trait :full do
      after(:create) do |test|
        for rank in 1..3 do
          create_list(:category, 3, :full, test_id: test.id, rank: rank)
        end
      end
    end

  end
end
