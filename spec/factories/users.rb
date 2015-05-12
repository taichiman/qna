FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    password = 123

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
      transient do 
        questions_count 2
        with_test_answers false
      end

      after(:create) do |user, evaluator|
        create_list(:question_with_answers,
          evaluator.questions_count,
          user: user 
        )

        if evaluator.with_test_answers
          create_pair :answer, user: user
        end
      end
    end
  end

end
