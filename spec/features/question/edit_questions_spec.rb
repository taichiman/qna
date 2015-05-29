require 'rails_helper'

feature 'User can edit question', %q{
  In order to be able to improve quality of my content
  As an author of answer
  I'd like to be able to edit my question with ajax
} do
  given(:question){ user.questions.first }

  feature 'when authenticated user' do
    given!(:title){ question.title }
    given!(:body){ question.body }

    background do
      fill_form_and_sign_in(question.user)
      visit question_path(question)
      first("a.edit-question[href='#{edit_question_path(question)}']").click

      fill_in 'Title', with: find('#question_title').value.upcase
      fill_in 'Body', with: find('#question_body').value.upcase
    end

    scenario 'edits question with valid data' do     
      click_on t('questions.form.submit')

      expect(current_path).to eq(question_path(question))
      expect(page).to have_content t('questions.update.succesfully')
      expect(page).to have_content title.upcase
      expect(page).to have_content body.upcase

    end

    scenario 'edits question with invalid data' do      
      fill_in 'Title', with: ''
      click_on t('questions.form.submit')

      expect(current_path).to eq(question_path(question))
      expect(page).to have_content t('questions.update.unsuccesfully')

      expect(page).to have_content('1 error prohibited this question from being saved:')
      expect(page).to have_content('Title can\'t be blank')

    end

    scenario 'tries to edit when not question owner' do
      visit edit_question_path(not_my_question)

      expect(current_path).to eq(my_questions_path)
      expect(page).to have_content t('question-not-owner')
      
    end
  end

  feature 'when unauthenticated user' do
    scenario 'tries to edit question' do  
      visit edit_question_path(question)
      expect(current_path).to eq(new_user_session_path)

    end
  end

end

