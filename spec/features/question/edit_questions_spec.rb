require 'rails_helper'

feature 'User can edit spec', %q{
  In order to be able to improve quality of my content
  As authenticated user
  I want to be able to edit my question
} do

  feature 'when authenticated user' do
    given(:user){ create :user_with_questions }
    given(:question){ user.questions.first }
    given!(:title){ question.title }
    given!(:body){ question.body }

    background do
      create_pair :user_with_questions
    end

    scenario 'edits question with valid data' do     
      fill_form_and_sign_in(user)
      visit '/'
      click_on t('links.my-questions')
      first('a.edit-question').click

      fill_in 'Title', with: find('#question_title').value.upcase
      fill_in 'Body', with: find('#question_body').value.upcase
      click_on t('questions.form.submit')

      expect(current_path).to eq(question_path(question))
      expect(page).to have_content t('questions.update.succesfully')
      expect(page).to have_content title.upcase
      expect(page).to have_content body.upcase

    end

    scenario 'edits question with invalid data'
  end

  feature 'when unauthenticated user' do
    scenario 'edits question'
  end

end

