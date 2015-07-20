require 'rails_helper'

feature 'Attach files to question', %q{
  In order to illustrate my question
  I as an question author
  I would like to be able to attach file to question
} do

  given(:user) { create :user }
  given(:question) { create :question }


  background do
    fill_form_and_sign_in user
    click_on 'Ask Question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
  end

  scenario 'user attachs a file when ask question' do
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on t('questions.form.submit')

    expect(page).to have_content('The Question created')
    expect(page).to have_content('spec_helper.rb')

    expect(page).to have_css('a[href="/uploads/attachment/file/1/spec_helper.rb"]')

  end

  scenario 'attachs many files at once', js: true do
    within '.attachments_form' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'add attachment'

    within '.attachments_form .nested-fields:nth-of-type(2)' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on t('questions.form.submit')

    expect(page).to have_content('The Question created')
    
    expect(page).to have_content('spec_helper.rb')
    expect(page).to have_css('a', text: 'spec_helper.rb')
    
    expect(page).to have_content('rails_helper.rb')
    expect(page).to have_css('a', text: 'rails_helper.rb')

  end

end

feature 'Delete attached files', js: true do
  given(:attachment){ create :attachment_with_question, add_answer_with_attachment: true }
  given(:question){ attachment.attachable }
  given(:user){ question.user }
  given(:answer){ question.answers.first }

  background do 
    fill_form_and_sign_in user
    visit question_path(question)
  end

  scenario 'delete files from question' do
    within '.question-content .attachments' do
      click_on 'Delete'

      expect(page).to_not have_content(question.attachments.first.file.identifier)
    end

  end

  scenario 'delete files from answer' do
    click_on 'Log out'
    fill_form_and_sign_in answer.user
    visit question_path(question)

    within '#answers .attachments' do
      click_on 'Delete'

      expect(page).to_not have_content(answer.attachments.first.file.identifier)
    end

  end

  scenario 'should not delete question attachment when user not attachable owner' do
    click_on 'Log out'
    user_not_owner = create :user
    fill_form_and_sign_in user_not_owner
    visit question_path(question)
    
    within '.question-content .attachments' do
      expect(page).to have_content(question.attachments.first.file.identifier)
      expect(page).to_not have_content('Delete')
    end

  end

end

