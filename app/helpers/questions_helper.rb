module QuestionsHelper
  def answer_count_legend(count)
    "#{count} #{t(:answer_count_legend).pluralize(count)}"
  end

  def my_questions_count(user)
    user.questions.count > 0 ? " (#{user.questions.count})" : ''
  end

end

