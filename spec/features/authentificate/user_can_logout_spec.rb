require 'rails_helper'

feature 'User can logout from the site', %q{
  In order to be able no one could edit my content
  As a logged in user
  I want to be able to logout
} do
 
  scenario 'user logouts from site' do
    fill_form_and_sign_in

    click_on 'Log out'
    expect(page).to have_content('Signed out successfully')
  end

end

