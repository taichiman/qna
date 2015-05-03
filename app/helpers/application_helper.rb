module ApplicationHelper
  def user_name user
    user.email.partition('@').first
  end

end
