FactoryGirl.define do
  factory :user do
    email      "me@maianhvu.com"
    password   "5eCr37-p45sW0rD"
    first_name "Anh Vu"
    last_name  "Mai"
    type       nil

    factory :user_without_email do
      email (" "*5)
    end

    factory :user_without_first_name do
      first_name nil
    end

    factory :user_without_last_name do
      last_name nil
    end
  end
end
