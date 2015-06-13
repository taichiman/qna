module QuestionsHelper
  def answer_count_legend(count)
    "#{count} #{t('answer-count-legend').pluralize(count)}"
  end

  def my_questions_count(user)
    user.questions.count > 0 ? " (#{user.questions.count})" : ''
  end

  def my_answers_count(user)
    user.answers.count > 0 ? " (#{user.answers.count})" : ''
  end
  
  def question_owner? question
    if current_user.nil?
      false
    else
      question.user_id == current_user.id
    end

  end

end

