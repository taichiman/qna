require 'rails_helper'

feature 'Attach files to answer', %q{
  In order to illustrate my answer
  I as an answer author
  I would like to be able to attach file to answer
} do

  given(:user) { create :user }
  given(:question) { create :question }
  given(:answer) { create :answer }

  background do
    fill_form_and_sign_in user
    visit question_path(question)
  end

  scenario 'user can attach many files when send answer', js: true do
    fill_in 'Your answer', with: answer.body

    within '.attachments_form' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'add attachment'
    within '.attachments_form .nested-fields:nth-of-type(2)' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on t('.questions.show.submit_answer')

    within '#answers' do
      expect(page).to have_content('spec_helper.rb')
      expect(page).to have_css('a', text: 'spec_helper.rb')
      
      expect(page).to have_content('rails_helper.rb')
      expect(page).to have_css('a', text: 'rails_helper.rb')
    end

  end

end

