# Cancan authorizes users according to these rules.
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.super_admin?
      can :manage, Role
      can :manage, User
      can :manage, Store
    end

    if user.admin?
      can :manage, Store do |store|
        store.users.include?(user)
      end

      can :manage, Product do |product|
        product.new_record? || product.store.users.include?(user)
      end
    end
  end
end
