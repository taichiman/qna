require 'rails_helper'

feature 'User can see list of questions', %q{
  In order to be able to see the list of the questions
  As an User
  I want to be able to go to Home page of the site
} do

  given(:questions){ create_pair :question }

  scenario 'An user visits Home page' do
    visit '/'

    expect(page).to have_content(t(:all_questions))
    expect(page).to have_content('Questions1')
    expect(page).to have_content('Questions2')
  end

  scenario 'An user clicks a link in navbar' do
    click_on 'All Question'

    expect(page).to have_content('All Questions')
    expect(page).to have_content('Questions1')
    expect(page).to have_content('Questions2')
  end
end