require 'rails_helper'

feature 'User can vote for question',%q{
  In order to be able provide quality questions
  As an User
  I can vote question up and down
} do
  given(:question){ create :question }
  
  scenario 'User can vote question up' do
    fill_form_and_sign_in
    visit question_path(question)

    within '.question-content .vote' do
      expect(page).to have_content(/^0$/)
      expect(page).to have_css('a.vote-up-off')
      expect(page).to have_css('a.vote-down-off')
      find('a.vote-up-off').click

      expect(page).to have_content(/^1$/)
      expect(page).to have_css('a.vote-up-on')
      expect(page).to have_css('a.vote-down-off')

    end
  end

end

