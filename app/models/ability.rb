# Cancan authorizes users according to these rules.
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    end

    if user.super_admin?
      can :manage, Role
      can :manage, User
    end

    can :manage, Store do |store|
      store.users.all.include?(user)
    end

    can :read, :all
  end
end
