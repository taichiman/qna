require 'rails_helper'

feature 'Best answer selecting', %q{
  In order to show a solving my question
  As a question owner
  I can select the best answer
} do
  given(:question){ create :question_with_answers, answers_count: 5 }


  feature 'can select a best answer' do
    background do
      fill_form_and_sign_in question.user
      visit question_path question

    end
    
    scenario 'answer was in random position' do
      answer = question.answers[rand(5)]
      click_on 'Best'

      expect(page).to have_selector 'in first position'
      expect(page).to have_selector 'count as initial answer count'
      expect(page).to have_selector 'for each answer'

    end

    scenario 'answer was in last position'
    scenario 'answer was in the first position'

  end

  feature 'can select an another answer as the best'

end

