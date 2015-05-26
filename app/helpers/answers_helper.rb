module AnswersHelper
  def answer_owner? answer
    if current_user.nil?
      false
    else
      answer.user_id == current_user.id
    end
  end

  def notify type, message
    "<div class='alert alert-#{type}' role='alert'>#{message}</div>".html_safe

  end
end

