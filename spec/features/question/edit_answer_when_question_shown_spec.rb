require 'rails_helper'

feature 'User can edit answer from question', %q{
  In order to be able to improove usability
  I as autenticated user
  Can edit my answers from question page
} do
  given(:question){ create :question_with_answers }

  feature 'User edits an answer' do

    def sign_in user
      fill_form_and_sign_in(user)
      visit question_path(question)
    end

    scenario 'when he is owner' do
      answer = create :answer, question: question
      sign_in(answer.user)

      expect(
        page.has_link?('', href: "#{edit_question_answer_path(question, answer)}")
      ).to eq true

    end
                        
    scenario 'should not when he is not owner' do
      answer = create :answer
      sign_in(answer.user)

      expect(page).to_not have_css('a.edit-answer')

    end

  end
  
  feature 'not authenticated user' do
    scenario 'should not edit any answer' do 
      visit question_path(question)

      expect(page).to_not have_css('a.edit-answer')
    end
  end

end

