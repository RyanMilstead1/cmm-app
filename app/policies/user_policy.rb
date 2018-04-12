class UserPolicy < ApplicationPolicy
  def show?
    user.present? ? user.id == record.id : false
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
