require 'rails_helper'

feature 'User can edit question', %q{
  In order to be able to improve quality of my content
  As an author of the question
  I'd like to be able to edit my question with ajax
} do
  given(:question){ create :question }

  feature 'when authenticated user', js: true do
    given!(:title){ question.title }
    given!(:body){ question.body }
    given(:not_my_question){ create :question }

    def form
      "form#edit_question_#{question.id}"
    end

    background do
      fill_form_and_sign_in(question.user)
      visit my_questions_path

      expect(page).to_not have_selector(form)
      find("a.edit-question-link").click
      expect(page).to     have_selector(form)

      fill_in 'Title', with: find('#question_title').value.upcase
      fill_in 'Body', with: find('#question_body').value.upcase
    end

    scenario 'edits question with valid data' do     
      click_on t('questions.question.update')

      expect(page).to have_content t('questions.update.succesfully')
      expect(page).to have_content title.upcase
      expect(page).to have_content body.upcase
      expect(page).to have_selector(form, visible: false )

    end

    scenario 'edits question with invalid data' do      
      fill_in 'Title', with: ''
      click_on t('questions.question.update')

      expect(page).to have_content t('questions.update.unsuccesfully')
      expect(page).to have_content('Title can\'t be blank')

    end

    scenario 'tries to attach file' do
      click_on 'add attachment'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on t('questions.question.update')
      expect(page).to have_css("#question_#{question.id} a", text: 'spec_helper.rb')

    end

    scenario 'tries to edit when not question owner' do
      visit question_path(not_my_question)
      expect(page).not_to have_selector("a.edit-question-link")

    end

    scenario 'edits from question_path' do
      visit question_path(question)

      expect(page).not_to have_selector("a.edit-question-link")

    end
  end

  feature 'when unauthenticated user' do
    scenario 'tries to edit question' do  
      visit question_path(question)
      expect(page).not_to have_selector("a.edit-question-link")

    end
  end

end

