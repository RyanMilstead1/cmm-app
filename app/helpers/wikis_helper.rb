module WikisHelper
  def is_authorized_to_make_private?
    current_user.admin? || current_user.premium?
  end

  def is_authorized_to_view?(wiki)
    !wiki.private || current_user == wiki.user || wiki.collaborating_users.include?(current_user) || current_user.admin?
  end

  def is_authorized_to_adjust_collaborators?(wiki)
    current_user.admin? || current_user == wiki.user
  end

  def user_info(id)
    User.find(id)
  end
end
