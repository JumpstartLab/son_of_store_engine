class AdminAbilityStore
  include CanCan::Ability
  def initialize(user)

    user ||= User.new
    if user.has_role? :site_admin
      cannot [:read], Store     
    
    elsif user.has_role? :store_admin
      can [:manage, :promote_users?], Store do |store|
        # x = ( store.admins.first.user == user )
        # raise user.inspect
        store.admins.select{ |admin| admin.user == user }.any?
        # raise store.admins.include?(user).inspect
      end

      can :manage, Category do |category|
        category.store.admins.include?(user)
      end

      can :update, Order do |category|
        order.store.admins.include?(user)
      end

      can :manage, Product do |product|
        product.store.admins.include?(user)
      end

    elsif user.has_role? :store_stocker

      can [:read], Store do |store|
        store.stockers.include?(user)
      end

      can [:manage], Product do |product|
        product.store.stockers.include?(user)
      end

    else
      can :read, Product
      can :read, Order do |order|
        order.user == user
      end
      can :update, User { |user_to_edit| user_to_edit == user }
    end
  end
end