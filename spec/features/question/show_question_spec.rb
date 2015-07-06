require 'rails_helper'

feature 'User can view question with its answers', %q{
  In order to be able to view question
  As an User
  I can see the question and its answers
} do
  
  scenario 'An user views question with few answers' do
    question = create :question_with_answers
    visit question_path(question)

    expect(page).to have_content(question.title, count: 1) 
    within('.question-content .body') do 
      expect(page).to have_content(question.body)
    end

    expect(page).to have_content(answer_count_legend(question.answers.count)) 
    question.answers.each do |answer|
      expect(page).to have_content(answer.body)
    end

    expect(page).to have_content(t('.questions.show.answer_title'))
    expect(page).to have_button(t('.questions.show.submit_answer'))

  end

  scenario 'An user views question with 0 answers' do
    question = create :question
    visit question_path(question)
    
    expect(page).to have_content(answer_count_legend(question.answers.count)) 
  end
end

