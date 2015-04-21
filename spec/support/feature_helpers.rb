module Features

  module ContentHelpers
    def page_have_content_question_list
      expect(page).to have_content(t(:all_questions))

      expect(page).to have_content(questions.first.title)
      expect(page).to have_content(questions.first.body)

      expect(page).to have_content(questions.second.title)
      expect(page).to have_content(questions.second.body)
    end

    def page_have_content_create_answer(question)
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
      expect(page).to have_field('Your Answer') 
    end

  end

  module AuthentificationHelpers
    def fill_and_sign_up(user)
      fill_in 'Email', with: user[:email]
      fill_in 'Password', with: user[:password]
      fill_in 'Password confirmation', with: user[:password_confirmation]
      click_button 'Sign up'
    end

    def fill_form_and_sign_in    
      visit new_user_session_path
      @user = create :user
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
    end

    def check_devise_sign_in_notification?
      expect(current_path).not_to eq(new_question_path)
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end

  end

end

