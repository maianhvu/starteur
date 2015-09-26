require 'faker'

FactoryGirl.define do
  factory :test do
    name "Starteur Profiling Assessment"
    description "Take the Starteur Profiling Assessment to discover your strengths and reveal your hidden entreprenuerial potential."
    price 10.0

    Test.aasm.states.each do |s|
      trait s do
        state s
      end
      factory "#{s.to_s}_test".to_sym, traits: [s]
    end

    factory :test_without_name do
      name " "*5
    end

    factory :test_without_price do
      price nil
    end

    factory :faked_test do
      name        { Faker::Book.title }
      description { Faker::Lorem.paragraph }
      price       { Faker::Number.decimal(2,1) }
      published

      factory :faked_unpublished_test, traits: [ :unpublished ]
    end
  end
end
