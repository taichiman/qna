FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    password = Faker::Internet.password

    trait :invalid_email do
      email nil
    end

    trait :invalid_password do
      password nil
    end
    
    email 
    password { password }
    password_confirmation { password }

    factory :user_with_questions do
      after(:create) { |user| create_pair :question_with_answers, user: user }
    end
  end

end
