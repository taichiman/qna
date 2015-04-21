require 'rails_helper'

feature 'Authenticated user can ask a question', %q{
  In order to be able to get answer from community
  As an authenticated user
  I want to be able to create question
} do

  given(:question) { build :question }
  
  feature 'when authenticated user' do
    scenario 'asks question with valid data' do
      fill_form_and_sign_in

      click_on 'Ask Question'
      expect(current_path).to eq(new_question_path)

      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body
      click_on 'Post Your Question'

      expect(page).to have_content('The Question created')
      expect(current_path).to eq(question_path(Question.last))
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)

    end

    scenario 'asks question with invalid data' do
      fill_form_and_sign_in

      click_on 'Ask Question'
      expect(current_path).to eq(new_question_path)

      click_on 'Post Your Question'

      expect(page).to have_content('Title can\'t be blank')
      expect(page).to have_content('Body can\'t be blank')
      expect(current_path).to eq(questions_path)

    end

  end

  feature 'when unauthenticated user' do
    scenario 'tries ask question' do
      visit root_path
      click_on 'Ask Question'

      check_devise_sign_in_notification?
    end

  end

end

