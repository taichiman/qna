require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to be able to improove content quality
  As author of an answer
  I'd like be able to edit my answers
}, js: true do
  given(:user){ create :user }
  given(:answer){ create :answer, user: user }
  given(:question){ answer.question }

  def edit_link
    "a.edit-answer-link"
  end

  feature 'User edits an answer when he is owner' do
    given(:upcased_body){ answer.body.upcase }

    def form_id
      "form#edit_answer_#{answer.id}"
    end

    def submit_form content
      expect(page).to have_selector(edit_link)
      expect(page).to have_selector(form_id, visible: false)
      
      find(edit_link).click

      within form_id do
        fill_in 'answer[body]', with: content
        click_on t('.answers.form.submit')      
      end

    end

    background do
      fill_form_and_sign_in(user)
      visit question_path(question)
    end

    scenario 'when owner' do
      submit_form(upcased_body)
        
      expect(page).to have_selector(form_id, visible: false)
      expect(page).to_not have_content(answer.body)
      expect(page).to have_content(upcased_body)

      expect(current_path).to eq(question_path(question))
      expect(page).to have_content(t('.answers.update.updated'))

    end

    scenario 'notification when invalid data' do
      submit_form ''

      expect(current_path).to eq(question_path(question))
      expect(page).to have_selector(form_id, visible: true)
      expect(page).to have_content("Body #{t('errors.messages.blank')}")
    end

  end
  
  feature 'when authenticated, but not owner' do
    given(:another_user){ create :user }

    background do
      fill_form_and_sign_in(another_user)
    end
    
    scenario 'should not see edit answer link' do
      visit question_path(question) 
      expect(page).to_not have_selector(edit_link, visible: :all)

    end

    scenario 'should raise exception if set edit url in browser', js: false do
      expect{ 
        visit "/questions/#{answer.question.id}/answers/#{answer.id}/edit" 
      }.to raise_error(ActionController::RoutingError)

    end 
  end

  scenario 'when unauthenticated should not edit' do
    visit question_path(question)
    expect(page).to_not have_selector(edit_link, visible: :all)
    
  end

  scenario 'when click edit after create an answer'
  # need using js event delegation to new created element
  
end

