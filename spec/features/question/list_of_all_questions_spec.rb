require 'rails_helper'

feature 'User can see list of all questions', %q{
  In order to be able to see the list of all questions
  As an User
  I want to be able to go to Home page of the site
} do

  given!(:questions){ create_pair :question }

  background do
    visit '/'
  end

  scenario 'An user visits Home page' do
    page_have_content_question_list(
      title: t('questions.index.all-questions'),
      questions: questions
    )
  end

  scenario 'An user clicks link in navbar' do
    click_on 'All Questions'
    page_have_content_question_list(
      title: t('questions.index.all-questions'),
      questions: questions
    )
  end
end
