FactoryGirl.define do
  factory :question do
    title Faker::Lorem.sentence
    body  Faker::Lorem.paragraph(2)
  end


  factory :invalid_question, class: Question do
    title Faker::Lorem.sentence
  end
end
