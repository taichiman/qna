FactoryGirl.define do
  factory :question do
    title Faker::Lorem.sentence
    body  Faker::Lorem.paragraph(2)
  end
end
