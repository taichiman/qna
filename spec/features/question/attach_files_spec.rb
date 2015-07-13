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
    expect(page).to have_link('spec_helper.rb'), href: "http://l:3000/uploads/attachment/file/1/spec_helper.rb"

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
    expect(page).to have_link('spec_helper.rb'), href: "http://l:3000/uploads/attachment/file/1/spec_helper.rb"
    
    expect(page).to have_content('rails_helper.rb')
    expect(page).to have_link('rails_helper.rb'), href: "http://l:3000/uploads/attachment/file/1/rails_helper.rb"

  end

end

