module QuestionsHelper
  def answer_count_legend(count)
    "#{count} #{t(:answer_count_legend).pluralize(count)}"
  end

end

