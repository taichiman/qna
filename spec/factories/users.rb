FactoryGirl.define do
  factory :user do
    password = Faker::Internet.password

    trait :invalid_email do
      email nil
    end

    trait :invalid_password do
      password nil
    end
    
    email    { Faker::Internet.email }
    password { password }
    password_confirmation { password }
  end

end
