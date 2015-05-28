require 'rails_helper'

feature 'User can delete owned him answer', %q{
  In order to be able to improve content quality
  As an Author
  I should to be able to delete my answer by ajax
} do
  given(:answer){ create :answer }
  given(:question){ answer.question }
  given(:user){ answer.user }
   
  def delete_answer_link
    "a.delete-answer-link[href='#{question_answer_path(answer.question, answer)}']"
  end

  def answer_body
    answer.body.truncate(10, omission: '')
  end

  
  feature 'author deletes answer from question page', js: true do
    scenario 'should delete owned answer' do
      fill_form_and_sign_in(user)
      visit question_path(question)

      expect(page).to have_selector(delete_answer_link)
      
      find(delete_answer_link).click

      expect(page).to have_content(t('answers.destroy.deleted'))
      expect(page).not_to have_content(answer_body)
    end
    
    
    scenario 'when request with curl'

  end
  
  feature 'delete answer from my answers page'

  scenario 'can not delete when unauthenticated user' do 
    visit my_answers_path
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content(t('.devise.failure.unauthenticated'))

  end
end

