FactoryGirl.define do
  factory :code_usage do
    access_code { FactoryGirl.build_stubbed(:access_code) }
    user        { FactoryGirl.build_stubbed(:user)        }
  end

end
