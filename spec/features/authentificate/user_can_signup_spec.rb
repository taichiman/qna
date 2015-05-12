require 'rails_helper'

feature 'User can signup', %q{
  In order to be registered user
  As an unregistered user
  I want to be able to fill register form
} do

  background do
    visit '/'
    click_link 'Sign up'
  end

  feature 'when succesfull signup' do
    scenario 'with valid email and password' do
      fill_and_sign_up( attributes_for(:user) )

      expect(page).to have_content('Welcome! You have signed up successfully')
      expect(current_path).to eq(root_path)
    end
  end

  feature 'when unsuccessfull signup' do
    scenario 'with invalid email' do
      fill_and_sign_up( attributes_for(:user, :invalid_email) ) 

      expect(page).not_to have_content('Welcome! You have signed up successfully')
      expect(page).to have_content('Email can\'t be blank')
      expect(current_path).to eq(user_registration_path)
    end

    scenario 'with invalid pasword' do
      fill_and_sign_up( attributes_for(:user, :invalid_password) ) 
      
      expect(page).not_to have_content('Welcome! You have signed up successfully')
      expect(page).to have_content('Password can\'t be blank')
      expect(current_path).to eq(user_registration_path)
    end
  end
end

