require 'rails_helper'

feature 'User can vote for question',%q{
  In order to be able provide quality questions
  As an User
  I can vote question up and down
} do
  given(:question){ create :question}

  scenario 'User can vote question up', js: true do
    fill_form_and_sign_in
    visit question_path(question)

    within '.question-content .vote' do
      expect(page).to have_content(/^0$/)
      expect(page).to have_css('a.vote-up')
      expect(page).not_to have_css('a.vote-up-on')
      expect(page).to have_css('a.vote-up-off')
      expect(page).to have_css('a.vote-down-off')
      find('a.vote-up').click

      expect(page).to have_content(/^1$/)
      expect(page).to have_css('a.vote-up')
      expect(page).not_to have_css('a.vote-up-off')
      expect(page).to have_css('a.vote-up-on')
      expect(page).to have_css('a.vote-down-off')

    end
  end

  scenario 'Question shows result votes counter' do 
    fill_form_and_sign_in
    
    1.upto(2){ create :vote, votable: question, vote_type: 'up' }
    1.upto(4){ create :vote, votable: question, vote_type: 'down' }

    visit question_path(question)
    
    within '.question-content .vote' do
      expect(page).to have_content(/^-2$/)
    end

  end

  describe 'user should cancel old vote if want revote', js: true do
    scenario 'user gets error message to cancel up' do
      vote = create :vote, votable: question, vote_type: 'up'
      fill_form_and_sign_in vote.user
      visit question_path(question)

      within '.question-content .vote' do
        expect(page).to have_content(/^1$/)
        expect(page).to have_css('a.vote-up-on')
        expect(page).not_to have_css('a.vote-up-off')
        expect(page).to have_css('a.vote-down-off')

        find('a.vote-down').click

        expect(page).to have_content(/^1$/)
        expect(page).to have_css('a.vote-up-on')
        expect(page).not_to have_css('a.vote-up-off')
        expect(page).to have_css('a.vote-down-off')

      end
    
      expect(page).to have_content(t('.votes.cancel-previous-vote'))

    end
    
    scenario 'user gets error message to cancel down' do
      vote = create :vote, votable: question, vote_type: 'down'
      fill_form_and_sign_in vote.user
      visit question_path(question)

      within '.question-content .vote' do
        expect(page).to have_content(/^-1$/)
        expect(page).to have_css('a.vote-down-on')
        expect(page).not_to have_css('a.vote-down-off')
        expect(page).to have_css('a.vote-up-off')
        expect(page).not_to have_css('a.vote-up-on')

        find('a.vote-up').click

        expect(page).to have_content(/^-1$/)
        expect(page).to have_css('a.vote-up-off')
        expect(page).not_to have_css('a.vote-down-off')
        expect(page).to have_css('a.vote-down-on')

      end
    
      expect(page).to have_content(t('.votes.cancel-previous-vote'))

    end

  end

  scenario 'user can cancel previous vote' do

  end

end

