require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to be able to improove content quality
  I as autenticated user
  Can edit my answers
} do
  given(:answer){ user.answers.first }
  given(:user){ create :user_with_questions, with_test_answers: true }

  feature 'User edits an answer when he is owner' do
    given(:upcased_body){ find('#answer_body').value.upcase }

    def edit_link
      find("a.edit-answer[href='#{edit_question_answer_path(answer.question, answer)}']")
    end

    background do
      fill_form_and_sign_in(user)
      visit '/'
      click_on t('links.my-answers')
      edit_link.click
    end

    scenario 'when owner' do
      fill_in 'Body', with: upcased_body
      click_on t('.answers.form.submit')
      expect(current_path).to eq(question_path(answer.question))
      expect(page).to have_content(upcased_body)
      expect(page).to have_content(t('.answers.update.updated'))

    end

    scenario 'edits when invalid data' do
      fill_in 'Body', with: ''
      click_on t('.answers.form.submit')
      expect(current_path).to eq(question_answer_path(answer.question, answer))
      expect(page).to have_content('prohibited this answer from being saved:')

    end

  end
  
  feature 'when not owner' do
    given(:another_user){ create :user }

    background do
      fill_form_and_sign_in(another_user)
    end
    
    scenario 'should not edit' do
      visit edit_question_answer_path(answer.question, answer)

      expect(current_path).to eq(my_answers_path)
      expect(page).to have_content(t('not-owner-of-answer'))

    end 
  end

end

