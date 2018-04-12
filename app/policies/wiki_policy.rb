class WikiPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    is_authorized_to_view_private?(record, user)
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user.present? && is_authorized_to_view_private?(record, user)
  end

  def edit?
    update?
  end

  def destroy?
    if user.present?
      user.admin? || (record.user.id == user.id)
    else
      false
    end
  end

  class Scope < Scope
    def resolve
      if user.admin?
        return scope.all
      else
        wikis = []
        scope.all.includes(:collaborating_users, :user).each do |wiki|
          if !wiki.private || wiki.collaborating_users.include?(user) || user == wiki.user || user.admin?
            wikis << wiki
          end
        end
      end

      wikis
    end
  end

  def is_authorized_to_view_private?(record, user)
    !record.private || record.collaborating_users.include?(user) || user == record.user || user.admin?
  end
end
