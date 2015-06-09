require 'rails_helper'

feature 'Best answer selecting', %q{
  In order to show a solving my question
  As a question owner
  I can select the best answer
} do
  given(:question){ create :question_with_answers, answers_count: 5 }
  given(:user){ question.user }

  feature 'can select a best answer' do
    Capybara.javascript_driver = :selenium

    background do
      #Capybara.default_wait_time = 5
      fill_form_and_sign_in user
      visit question_path(question)
    end
    
    scenario 'answer was in random position', js: true do
      answer = question.answers[ rand(1..question.answers.count) ]
      find("#answer_#{answer.id}").click_on 'Best'

      within('#answers') do
        expect(page.first(".answer")[:id]).to eq("answer_#{answer.id}")
        #'best answer has green check' 
        #expect(page).to have_selector 'count as initial answer count' 
        #expect(page).to have_selector 'for each answer'
      end

    end

    scenario 'answer was in last position'
    scenario 'answer was in the first position'

  end

  feature 'can select an another answer as the best' do

  end

end

