# Cancan authorizes users according to these rules.
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.super_admin?
      can :manage, Role
      can :manage, User
      can :manage, Store
      can :manage, Product
      can :manage, Category
      can :manage, Order
      can :manage, :stores
    end

    if user.admin?
      can :manage, Store do |store|
        store.users.include?(user) if store
      end

      can :manage, Category do |category|
        category.new_record? || 
          category.store.users.include?(user)
      end

      can :manage, Product do |product|
        product.new_record? || product.store.users.include?(user)
      end

      can :manage, Order do |order|
        order.store.users.include?(user) if order.store
      end
    end

    if user.stocker?
      can :manage, Product do |product|
        product.new_record? || product.store.users.include?(user)
      end
    end
  end
end
