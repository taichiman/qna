FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
    question
    user
    
    factory :invalid_answer do
      body nil
    end
  end
end
