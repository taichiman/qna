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
end

