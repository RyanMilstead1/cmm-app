class ChargePolicy < ApplicationPolicy
  def new?
    user.present? ? user.standard? : false
  end

  def create?
    user.present? ? user.standard? : false
  end

  def destroy?
    user.present? ? user.premium? : false
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
