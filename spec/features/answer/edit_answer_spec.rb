require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to be able to improove content quality
  As author of an answer
  I'd like be able to edit my answers
}, js: true do
  given(:user){ create :user }
  given(:answer){ create :answer, user: user }
  given(:question){ answer.question }

  feature 'User edits an answer when he is owner' do
    given(:upcased_body){ answer.body.upcase }

    def edit_link
      "a.edit-answer-link[href='#{edit_question_answer_path(answer.question, answer)}']"
    end

    def form_id
      "form#edit_answer_#{answer.id}"
    end

    background do
      fill_form_and_sign_in(user)
      visit question_path(question)
    end

    scenario 'when owner' do
      expect{ find(edit_link) }.to_not raise_error
      expect(page).to have_selector(form_id, visible: false)

      find(edit_link).click

      within form_id do
        fill_in 'answer[body]', with: upcased_body
        click_on 'Update answer'
      
        expect(page).to_not have_selector('textarea')
      end
        
      expect(page).to have_selector(form_id, visible: false)
      expect(page).to_not have_content(answer.body)
      expect(page).to have_content(upcased_body)

      expect(current_path).to eq(question_path(question))
      expect(page).to have_content(t('.answers.update.updated'))

    end

    scenario 'edits when invalid data' do
      fill_in 'Body', with: ''
      click_on t('.answers.form.submit')
      expect(current_path).to eq(question_answer_path(answer.question, answer))
      expect(page).to have_content('prohibited this answer from being saved:')

    end

  end
  
  feature 'when not owner' do
    given(:another_user){ create :user }

    background do
      fill_form_and_sign_in(another_user)
    end
    
    scenario 'should not edit' do
      visit edit_question_answer_path(answer.question, answer)

      expect(current_path).to eq(my_answers_path)
      expect(page).to have_content(t('not-owner-of-answer'))

    end 
  end

  scenario 'when unauthenticated' do
    visit question_path(question)
    
    #TODO ref to edit_link method
    expect(
      page.has_link?('', href: "#{edit_question_answer_path(question, answer)}")
    ).to eq false

  end

end

