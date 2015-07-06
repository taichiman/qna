require 'rails_helper'

feature 'User can delete question', %q{
  In order to be able to improove content
  As authentificated user
  I want to be able to delete my question with ajax
} do

  def delete_link
    find("a.delete-question[href='#{question_path(question)}']")
  end

  feature 'when authenticated user', js: true do
    background do
      fill_form_and_sign_in(question.user)
      visit my_questions_path
      delete_link.click
    end

    feature 'owned question with an answers' do
      given(:question){ create :question_with_answers }
      
      scenario 'should not delete' do
        expect(page).to have_content(t('questions.destroy.not-deleted'))

      end
    end

    feature 'owned question without an answers' do
      given(:question) { create :question }

      scenario 'should delete' do 
         expect(page).to have_content(t('questions.destroy.deleted'))
        
      end
    end
    
  end
  
  feature 'when unauthenticated user tries' do
    given(:question){ create :question }

    scenario 'should not see delete link' do
      visit question_path(question)

      expect{ delete_link }.to raise_exception(Capybara::ElementNotFound)

    end
  end

end
  
