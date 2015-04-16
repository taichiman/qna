require 'rails_helper'

feature 'User can login to the site', %q{
  In order to be able to login to the site
  As an User
  I want to fill Login form
  Then I will be logged to site
} do

  scenario 'fill form with valid password' do
    User.create(email:'user@test.com', password: 123)
    visit new_user_session_path

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123'
    click_on 'Log in'

    expect(page).to have_content('Signed in successfully')
    expect(current_path).to eq(root_path)
  end
  scenario 'fill form with invalid password'

  scenario 'Non-register user try to sign in' do
    visit new_user_session_path

    fill_in 'Email', with: 'user1@test.com'
    fill_in 'Password', with: '123'
    click_on 'Log in'

    expect(page).to have_content('Invalid email or password')
    expect(current_path).to eq(new_user_session_path)
    
  end

  scenario 'Registered user try to signin' do


  end
end
