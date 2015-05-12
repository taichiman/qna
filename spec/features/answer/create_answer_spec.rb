require 'rails_helper'

feature 'User can create answers', %q{
  In order to be able to answer
  As an User
  I want to be able to fill and submit its form
} do

  given(:question){ Question.first }

  background :all do
    create_pair :question_with_answers
  end

  feature 'when any user' do
    scenario 'An user select the question from question list' do
      visit '/'
      click_on question.title

      expect(page).to have_content(question.body)
      expect(page).to have_content(question.title, count: 1)
    end

  end

  feature 'when authenticated user' do
    feature 'An user creates an answer' do
      background do
        fill_form_and_sign_in 
        visit question_path(question)
        click_on 'Create answer'
      end
        
      scenario 'success with valid parameters' do
        page_have_content_create_answer(question)
        
        fill_in 'Your Answer', with: attributes_for(:answer)[:body]
        
        expect{ click_on 'Post Your Answer' }.to change(Answer, :count)
        
        expect(current_path).to eq(question_path(question))
      end

      scenario 'error with invalid parameters' do
        page_have_content_create_answer(question)
        
        fill_in 'Your Answer', with: nil
        
        expect{ click_on 'Post Your Answer' }.not_to change(Answer, :count)

        expect(page).to have_content('Body can\'t be blank')
        expect(current_path).to eq(question_answers_path(question))
      end
    end

  end

  feature 'when unauthenticated user' do
    scenario 'tries create answer' do
      visit question_path(question)
      click_on 'Create answer'

      check_devise_sign_in_notification?

    end

  end

end

