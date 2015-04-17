require 'rails_helper'

feature 'User can logout from the site', %q{
  In order to be able no one could edit my content
  As a logged in user
  I want to be able to logout
} do
 
  background do
    User.create(email: 'user@test.com', password: '123')
    visit '/'
    click_on 'Log in'

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123'
    click_button 'Log in'
  end  

  scenario 'user logouts from site' do
    click_on 'Log out'
    expect(page).to have_content('Signed out successfully')
  end

end

