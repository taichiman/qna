require 'rails_helper'

feature 'Authenticated user can ask a question', %q{
  In order to be able to get answer from community
  As an authenticated user
  I want to be able to create question
} do

  given(:question) { build :question }
  
  scenario 'An authenticated user ask question' do
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

  scenario 'The authenticated user submits question form with a validate error' do
    fill_form_and_sign_in

    click_on 'Ask Question'
    expect(current_path).to eq(new_question_path)

    click_on 'Post Your Question'

    expect(page).to have_content('Title can\'t be blank')
    expect(page).to have_content('Body can\'t be blank')
    expect(current_path).to eq(questions_path)
  end

  scenario 'An unauthenticated user ask question' do
    visit root_path
    click_on 'Ask Question'
    
    expect(current_path).not_to eq(new_question_path)
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

end
