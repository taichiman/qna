# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

include FactoryGirl::Syntax::Methods

# user
#   without questions
create :user

# user:
#   with question
create :user do |user|
  user.questions.create(attributes_for(:question))
end

#   with question with one answer
create :user do |user|
  create :question_with_answers, answers_count: 1, user: user
  #user.questions << create(:question_with_answers, answers_count: 1) 
end
#   with question with answers
create :user do |user|
  create(:question_with_answers, user: user)
end

# user:
#   with questions with answers
#
create_list :user_with_questions, 2

