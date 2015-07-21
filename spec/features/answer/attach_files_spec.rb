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

  scenario 'user attachs a file when send answer', js: true do
    fill_in 'Your answer', with: answer.body

    click_on 'add attachment'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on t('.questions.show.submit_answer')

    within '#answers' do
      expect(page).to have_content('spec_helper.rb')
      expect(page).to have_link('spec_helper.rb'), href: "http://l:3000/uploads/attachment/file/1/spec_helper.rb"
    end

  end

end

