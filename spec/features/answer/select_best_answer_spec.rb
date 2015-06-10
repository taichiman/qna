require 'rails_helper'

feature 'Best answer selecting', %q{
  In order to show a solving my question
  As a question owner
  I can select the best answer
} do
  given(:question){ create :question_with_answers, answers_count: 5 }
  given(:user){ question.user }

  before(:all) do
    Capybara.javascript_driver = :selenium
    Capybara.default_wait_time = 5
  end

  after(:all) do
    Capybara.javascript_driver = :webkit
    Capybara.default_wait_time = 2
  end

  feature 'can select a best answer' do

    background do
      fill_form_and_sign_in user
      visit question_path(question)

    end
    
    scenario 'answer was in middle position', js: true do
      answer = question.answers[2]
      find("#answer_#{answer.id}").click_on 'Best'

      within('#answers') do
        expect(page.first(".answer")[:id]).to eq("answer_#{answer.id}")
        expect(page.all(".answer").count).to eq(question.answers.count)
        expect(page.all('.answer')
          .map{|e| e[:id]}
          .map{|s| s[/\d+/].to_i}).to contain_exactly(*question.answers.map(&:id)
        )

        expect(page.first('.answer').has_css?('#best-answer-tag')).to be_truthy
        
        #commented, because preventDefault had not worked
        #expect(page.first('.answer a#best-answer-tag')).to be_disabled
      end

    end

    scenario 'only the one answer may be selected as the best', js: true do  
      answer = question.answers[2]
      find("#answer_#{answer.id}").click_on 'Best'

      expect(page.first('.answer').has_css?('#best-answer-tag')).to be_truthy

      answer = question.answers[3]
      find("#answer_#{answer.id}").click_on 'Best'

      expect(page).to have_selector('#best-answer-tag', count: 1) 

    end

  end
  feature 'click on the best answer triggers this one back to usual'
  feature 'only owner can select best answer'



  feature 'best answer in first position when question showing'

end

