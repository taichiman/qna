require 'rails_helper'

feature 'User can create answers', %q{
  In order to be able to exchange of knowledge
  As an User
  I want to be able to answer
} do
  
  def submit_body(text)
    find('#new_answer').
      fill_in 'answer_body', with: text
    click_on t('.questions.show.submit_answer')
  end

  given(:question){ create :question }
  given(:answer){ attributes_for :answer }

  feature 'when authenticated user', js: true do
    feature 'creates an answer' do
      background do
        fill_form_and_sign_in 
        visit question_path(question)
      end
        
      scenario 'success with valid parameters' do
        submit_body(answer[:body])

        expect(page).to have_content(answer[:body])
        expect(find_field('answer_body').value).to eq('')
        expect(current_path).to eq(question_path(question)) 
        
        #TODO expect(page).to have_content(t('.answers.create.success_create_answer'))

      end

      scenario 'then error with invalid parameters' do
        submit_body('') 

        expect(page).to have_content('Body can\'t be blank')
        expect(current_path).to eq(question_path(question))

      end
    end

  end
  
  #TODO
  #feature 'when unauthenticated user' do
    #scenario 'should not create answer' do
      #visit question_path(question)
      #submit_body(answer[:body])

      #check_devise_sign_in_notification?

    #end
  #end

end

