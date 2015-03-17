
FactoryGirl.define do
  factory :question do
    title 'foo'
    body  'bar'
  end

  factory :answer do
    body 'baz'
  end
end
