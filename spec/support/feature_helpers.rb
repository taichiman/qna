module FeatureHelpers
  def page_have_content_question_list
    expect(page).to have_content(t(:all_questions))

    expect(page).to have_content(questions.first.title)
    expect(page).to have_content(questions.first.body)

    expect(page).to have_content(questions.second.title)
    expect(page).to have_content(questions.second.body)
  end
end