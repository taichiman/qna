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

  scenario 'An user select the question from question list' do
    visit '/'
    click_on question.title

    expect(page).to have_selector('a.question-hyperlink', text: question.title, count: 1)
    expect(page).to have_content(question.body)
  end

  scenario 'An user creates an answer' do
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(page).to have_field('Your Answer')
    
    fill_in 'Your Answer', with: attributes_for(:answer)[:body]
    
    expect{ click_on 'Post Your Answer' }.to change(Answer, :count)
  end

  scenario 'An user can\'t creates an invalid answer' do
    # given(## answer with blank body)
  end

end
