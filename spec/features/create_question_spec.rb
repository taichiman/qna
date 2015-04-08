require 'rails_helper'

feature 'User can ask a question', %q{
  In order to be able to ask the question
  As an user
  I want to be able to fill and to submit a question form
} do

  scenario 'An user fills and submits a question form' do
    title = 'foo'
    body = 'bar'

    visit root_path
    click_on 'Ask Question'
    expect(current_path).to eq(new_question_path)

    fill_in 'Title', with: title
    fill_in 'Body', with: body
    click_on 'Post Your Question'

    expect(page).to have_content('The Question created')
    expect(current_path).to eq(question_path(Question.last))
    expect(page).to have_content(title)
    expect(page).to have_content(body)
  end

  scenario 'The user submits the question form with a validate error' do
    visit root_path
    click_on 'Ask Question'
    expect(current_path).to eq(new_question_path)

    click_on 'Post Your Question'

    expect(page).to have_content('Title can\'t be blank')
    expect(page).to have_content('Body can\'t be blank')
    expect(current_path).to eq(questions_path)
  end
end