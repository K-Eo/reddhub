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
end
