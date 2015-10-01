FactoryGirl.define do
  factory :answer do
    question { FactoryGirl.build_stubbed(:question)       }
    user     { FactoryGirl.build_stubbed(:confirmed_user) }
    test     { FactoryGirl.build_stubbed(:faked_test)     }
    value    1
  end

end
