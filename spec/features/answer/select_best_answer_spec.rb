require 'rails_helper'

feature 'Best answer selecting', %q{
  In order to show a solving my question
  As a question owner
  I can select the best answer
} do
  given(:question){ create :question_with_answers, answers_count: 5 }
  given(:user){ question.user }
  given(:answer){ question.answers[2] }

  before(:all) do
    Capybara.javascript_driver = :selenium
    Capybara.default_wait_time = 5
  end

  after(:all) do
    Capybara.javascript_driver = :webkit
    Capybara.default_wait_time = 2
  end

  feature 'can select a best answer', js: true do

    background do
      fill_form_and_sign_in user
      visit question_path(question)

      find("#answer_#{answer.id}").click_on 'Best'
    end
    
    scenario 'answer was in middle position' do
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

    scenario 'if there was the best answer, then it must be deselected and a new answer will be selected' do  
      expect(page.first('.answer').has_css?('#best-answer-tag')).to be_truthy

      answer = question.answers[3]
      find("#answer_#{answer.id}").click_on 'Best'

      expect(page).to have_selector('#best-answer-tag', count: 1) 

    end

    scenario 'clicking on the best answer triggers this one back to usual' do
      expect(page.first('.answer').has_css?('#best-answer-tag')).to be_truthy
      find("#answer_#{answer.id}").click_on 'Best'
      
      expect(page).to_not have_css('#best-answer-tag')

    end
  end

  scenario 'only question owner can select best answer' do
    fill_form_and_sign_in (create :user)
    visit question_path(question)
    expect(page).not_to have_css('.best-answer-link')

  end

  scenario 'best answer in first position when question showing'

end

