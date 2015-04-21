require 'rails_helper'

feature 'User can sign in', %q{
  In order to be able to ack question
  As an User
  I want to be able to sign in
} do

  scenario 'registered user try to sign to site' do
    fill_form_and_sign_in

    expect(page).to have_content('Signed in successfully')
    expect(current_path).to eq(root_path)
  end

  scenario 'Non-register user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123'
    click_button 'Log in'

    expect(page).to have_content('Invalid email or password')
    expect(current_path).to eq(new_user_session_path)
  end

end

