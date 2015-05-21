module AnswersHelper
  def answer_owner? answer
    answer.user_id == current_user.id
  end

end

