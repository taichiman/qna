require 'rails_helper'

feature 'User can vote for question',%q{
  In order to be able provide quality questions
  As an User
  I can vote question up and down
} do
  given(:question){ create :question}

  describe 'User can vote for question', js: true do
    scenario '"up"' do
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

    scenario '"down"' do
      fill_form_and_sign_in
      visit question_path(question)

      within '.question-content .vote' do
        expect(page).to have_content(/^0$/)

        expect(page).to have_css('a.vote-up')
        expect(page).to have_css('a.vote-up-off')
        expect(page).not_to have_css('a.vote-up-on')

        expect(page).to have_css('a.vote-down')
        expect(page).to have_css('a.vote-down-off')
        expect(page).not_to have_css('a.vote-down-on')

        find('a.vote-down').click

        expect(page).to have_content(/^-1$/)

        expect(page).to have_css('a.vote-down')
        expect(page).to have_css('a.vote-down-on')
        expect(page).not_to have_css('a.vote-down-off')

        expect(page).to have_css('a.vote-up')
        expect(page).to have_css('a.vote-up-off')
        expect(page).not_to have_css('a.vote-up-on')

      end
    end
  end

  describe 'Voting statistics' do
    scenario 'Question shows result votes counter' do 
      fill_form_and_sign_in
      
      1.upto(2){ create :vote, votable: question, vote_type: 'up' }
      1.upto(4){ create :vote, votable: question, vote_type: 'down' }

      visit question_path(question)
      
      within '.question-content .vote' do
        expect(page).to have_content(/^-2$/)
      end

    end

  end

  describe 'Revoting' do
    describe 'user should cancel old vote if wants to revote', js: true do
      given(:user) { create :user }

      background do
        fill_form_and_sign_in user
        allow(Vote).to receive(:current_user) { user }

      end

      scenario 'user gets error message to cancel "up"' do
        vote = create :vote, votable: question, vote_type: 'up', user: user
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
      
        expect(page).to have_content(t('.votes.cancel-previous-vote-suggestion'))

      end
      
      scenario 'user gets error message to cancel "down"' do
        vote = create :vote, votable: question, vote_type: 'down', user: user
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
      
        expect(page).to have_content(t('.votes.cancel-previous-vote-suggestion'))

      end

    end

  end

  scenario 'user can cancel previous vote'

end

