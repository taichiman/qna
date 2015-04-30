require 'rails_helper'

feature 'User can delete question', %q{
  In order to be able to clear my bad content
  As authentificated user
  I want to be able to delete my question
} do
  
  feature 'Delete question' do
    feature 'when authenticated user' do
      given!(:user) { create :user_with_questions }
      given(:question) { user.questions.first }
    
      feature 'deletes owned him questions' do
        scenario 'should not delete when there are an answers', js: true do 
          fill_form_and_sign_in(user)
          visit '/'
          click_on t('links.my-questions')      
          link = find("a.delete-question[href='#{question_path(question)}']")
          link.click

          expect(page).to have_content(t('questions.destroy.not-deleted'))

        end

        scenario 'without answers' do

        end
      end

      scenario 'deletes not owned him question'

    end
  end
    
  scenario 'when unauthenticated user'

end

