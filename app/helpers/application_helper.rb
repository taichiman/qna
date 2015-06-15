module ApplicationHelper
  def user_name(user)
    user.email.partition('@').first

  end

  def notify(type, message)
    "<div class='alert alert-#{type}' role='alert'>#{message}</div>".html_safe

  end
end

