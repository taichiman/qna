require 'rails_helper'

feature 'User can delete question', %q{
  In order to be able to clear my bad content
  As authentificated user
  I want to be able to delete my question
} do

  def delete_link
    find("a.delete-question[href='#{question_path(question)}']")
  end

  feature 'when authenticated user' do
    background do
      fill_form_and_sign_in(user)
      visit '/'
      click_on t('links.my-questions')      
      delete_link.click
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

      scenario 'should delete', js: true do 
         expect(page).to have_content(t('questions.destroy.deleted'))
        
      end
    end
    
  end
  
  feature 'when unauthenticated user tries' do
    given(:question){ create :question }
    scenario 'should not see delete link' do
      visit '/'
      expect{ delete_link }.to raise_exception(Capybara::ElementNotFound)

    end
  end

end
  
