require 'rails_helper'

feature 'User can see lists of his questions', %q{
  I order to be able to manage my question
  As an authenticated user
  I want to be able to see list of my questions
} do

  given(:user){ create :user_with_questions }
  
  background do
    create_pair :user_with_questions
  end

  scenario 'list of my questions' do
    fill_form_and_sign_in(user)
    visit '/'
    click_on t('links.my-questions')
    
    page_have_content_question_list(
      title: t('questions.index.my-questions'),
      questions: user.questions
    )
  end
  
  scenario 'when I unauthenticated' do
    visit '/'
    expect(page).not_to have_content t('links.my-questions')

  end

end

