FactoryGirl.define do
  factory :answer do
    choice { FactoryGirl.build_stubbed(:choice)         }
    user   { FactoryGirl.build_stubbed(:confirmed_user) }
    test   { FactoryGirl.build_stubbed(:faked_test)     }
  end

end
