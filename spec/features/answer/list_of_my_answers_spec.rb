require 'rails_helper'

feature '', %q{
  In order to be able to manage my answers
  As an User
  I can see list of my answers
} do
  background do
    create_pair :user_with_questions
  end

  scenario 'shows list of my answers' do
    user = create :user_with_questions, with_test_answers: true
    fill_form_and_sign_in(user)
    visit '/'
    click_on t('links.my-answers')

    page_have_content_answers_list(
      title: t('answers.index.my-answers'),
      answers: user.answers
    )

  end
  
  scenario 'does not show when unauthenticated user' do
    visit '/'
    expect(page).to_not have_content(t('links.my-answers'))

  end

end

