require 'rails_helper'

feature 'User can delete owned him answer', %q{
  In order to be able to improve content quality
  As an user
  I should to be able to delete my answer
} do
  
  def delete_answer_link
    find("a.delete-answer[href='#{question_answer_path(answer.question, answer)}']")
  end

  def answer_body
    answer.body.truncate(10, omission: '')
  end

  feature 'delete answer from my answers page' do
    background do
      fill_form_and_sign_in(user)
      visit '/'
      click_on t('links.my-answers')
    end

    describe 'when authenticated user' do
      given(:user){ create :user_with_questions, with_test_answers: true }
      given(:answer){ user.answers.first }
      
      scenario 'should delete answer' do
        expect(page).to have_content(answer_body)
        delete_answer_link.click

        expect(page).to have_content(t('answers.destroy.deleted'))
        expect(current_path).to eq(my_answers_path)
        expect(page).not_to have_content(answer_body)
      end
    end

  end
    
  scenario 'can not delete when unauthenticated user' do 
    visit my_answers_path
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content(t('.devise.failure.unauthenticated'))

  end
end

