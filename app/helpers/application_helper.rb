module ApplicationHelper
  def user_name(user)
    user.email.partition('@').first

  end

  def notify(type, message)
    "<div class='alert alert-#{type}' role='alert'>#{message}</div>".html_safe

  end

  def owner? obj
    !current_user.nil? && current_user.owner_of?(obj)
  end

end

