require 'rails_helper'

feature 'User can vote for question',%q{
  In order to be able provide quality questions
  As an User
  I can vote question up and down
} do
  given(:question){ create :question}
  given(:user) { create :user }

  describe 'user can vote for question', js: true do
    background do
      fill_form_and_sign_in user
      visit question_path(question)

    end
  
    scenario '"up"' do
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
      1.upto(2){ create :vote, votable: question, vote_type: 'up' }
      1.upto(4){ create :vote, votable: question, vote_type: 'down' }

      visit question_path(question)
      
      within '.question-content .vote' do
        expect(page).to have_content(/^-2$/)
      end

    end

    context 'try changing the vote counter value', js: true do
      let(:question) { create :question }
      let(:user) { create :user }

      before do
        1.upto(2) do
          user = create :user
          create :vote, user: user, votable: question, vote_type: 'up'
        end 

        fill_form_and_sign_in user

      end

      scenario 'to increase' do
        visit question_path(question)

        within '.question-content .vote' do
          #TODO I think, mybe exclude it in common method 
          expect(page).to have_css('a.vote-up-off')
          expect(page).to have_css('a.vote-down-off')
          expect(page).to have_content(/^2$/)
          ##

          find('a.vote-up').click

          expect(page).to have_css('a.vote-up-on')
          expect(page).to have_css('a.vote-down-off')
          expect(page).to have_content(/^3$/)

        end

      end

      scenario 'to decrease' do
        visit question_path(question)

        within '.question-content .vote' do
          expect(page).to have_css('a.vote-up-off')
          expect(page).to have_css('a.vote-down-off')
          expect(page).to have_content(/^2$/)

          save_and_open_page
          find('a.vote-down').click

          expect(page).to have_css('a.vote-up-off')
          expect(page).to have_css('a.vote-down-on')
          expect(page).to have_content(/^1$/)

        end


      end

      scenario 'to negative value'

      #TODO think: if there need scenario, changing the counter after cancel vote

      xscenario 'ajax request changes vote counter', js: true do
        within '.question-content .vote' do
          expect(page).to have_content(/^0$/)
          find('a.vote-down').click
          expect(page).to have_content(/^-1$/)
          find('a.vote-up').click
          expect(page).to have_content(/^0$/)
          find('a.vote-up').click
          expect(page).to have_content(/^1$/)
          find('a.vote-up').click
          expect(page).to have_content(/^2$/)
      
        end

      end

    end

  end

  describe 'Revoting', js: true do
    background do
      fill_form_and_sign_in user
      visit question_path(question)

    end
  
    context 'when user clicks new vote' do
      describe 'he should see error message about cancel' do
        scenario 'previous "up" first' do
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
        
        scenario 'previous "down" first' do
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

    context 'when user clicks previous vote' do
      describe 'system should cancel that vote' do
        scenario 'cancel "up"' do
          vote = create :vote, votable: question, vote_type: 'up', user: user
          visit question_path(question)

          within '.question-content .vote' do
            expect(page).to have_css('a.vote-up-on')
            expect(page).to have_css('a.vote-down-off')
            expect(page).to have_content(/^1$/)

            find('a.vote-up').click

            expect(page).to have_css('a.vote-up-off')
            expect(page).to have_css('a.vote-down-off')
            expect(page).to have_content(/^0$/)

          end

          expect(page).to have_content(t('.votes.success-previous-vote-cancel'))

        end

        scenario 'cancel "down"' do
          vote = create :vote, votable: question, vote_type: 'down', user: user
          visit question_path(question)

          within '.question-content .vote' do
            expect(page).to have_css('a.vote-down-on')
            expect(page).to have_css('a.vote-up-off')
            expect(page).to have_content(/^-1$/)

            find('a.vote-down').click

            expect(page).to have_css('a.vote-up-off')
            expect(page).to have_css('a.vote-down-off')
            expect(page).to have_content(/^0$/)

          end

          expect(page).to have_content(t('.votes.success-previous-vote-cancel'))

        end

      end

    end

  end

end

