class StoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    @user.present?
  end

  def update?
    @record.user == @user
  end

  def destroy?
    update?
  end

  def publish?
    @record.title.present?
  end

  class Scope < Scope
    def resolve
      scope.where(user: user).includes(:user)
    end
  end
end
