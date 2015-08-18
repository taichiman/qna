FactoryGirl.define do
  factory :vote do
    votable { create :question }
    user

  end

end

