require 'rails_helper'

feature 'User can login', %q{
  In order to be able to ack question
  As an User
  I want to be able to signin
} do

  background do
    visit new_user_session_path
  end
  
  scenario 'registered user try to sign to site' do
    User.create(email:'user@test.com', password: 123)
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123'
    click_button 'Log in'

    expect(page).to have_content('Signed in successfully')
    expect(current_path).to eq(root_path)
  end

  scenario 'Non-register user try to sign in' do
    fill_in 'Email', with: 'user_1@test.com'
    fill_in 'Password', with: '123'
    click_button 'Log in'

    expect(page).to have_content('Invalid email or password')
    expect(current_path).to eq(new_user_session_path)
  end

end

