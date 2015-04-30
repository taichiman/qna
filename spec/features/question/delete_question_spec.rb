require 'rails_helper'

feature 'User can delete question', %q{
  In order to be able to clear my bad content
  As authentificated user
  I want to be able to delete my question
} do
  
  feature 'delete question' do
    feature 'when authenticated user' do
      background do
        fill_form_and_sign_in(user)
        visit '/'
        click_on t('links.my-questions')      
        link = find("a.delete-question[href='#{question_path(question)}']")
        link.click
      end

      feature 'owned question with an answers' do
        given(:user) { create :user_with_questions }
        given(:question) { user.questions.first }
        
        scenario 'should not delete', js: true do 
          expect(page).to have_content(t('questions.destroy.not-deleted'))

        end
      end

      feature 'owned question without an answers' do
        given(:user) do
          user = create(:user)
          user.questions = [
            create(:question_with_answers, answers_count: 0),
            create(:question_with_answers)
          ]
          user
        end
        given(:question) { user.questions.first }

         scenario 'should deletes', js: true do 
           expect(page).to have_content(t('questions.destroy.deleted'))
          
        end
      end

      scenario 'deletes not owned him question'

    end
  end
    
  scenario 'when unauthenticated user'

end

