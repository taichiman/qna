require 'rails_helper'

feature 'User can see list of questions', %q{
  In order to be able to see the list of the questions
  As an User
  I want to be able to go to Home page of the site
} do

  given!(:questions){ create_pair :question }

  scenario 'An user visits Home page' do
    visit '/'

    expect(page).to have_content(t(:all_questions))

    expect(page).to have_content(questions.first.title)
    expect(page).to have_content(questions.first.body)
    expect(page).to have_content(questions.second.title)
    expect(page).to have_content(questions.second.body)
  end

  scenario 'An user clicks a link in navbar' do
    visit '/'
    click_on 'All Questions'

    expect(page).to have_content(t(:all_questions))

    expect(page).to have_content(questions.first.title)
    expect(page).to have_content(questions.first.body)
    expect(page).to have_content(questions.second.title)
    expect(page).to have_content(questions.second.body)
  end
end
