# Cancan authorizes users according to these rules.
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    end

    can :manage, Store do |store|
      store.user == user
    end

    can :read, :all
  end
end
