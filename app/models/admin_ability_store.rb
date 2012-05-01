class AdminAbilityStore
  include CanCan::Ability
  def initialize(user)

    user ||= User.new
    if user.has_role? :site_admin
      
    elsif user.has_role? :store_admin
      can [:manage, :read], Store do |store|
        store.admins.include?(user)
      end
    elsif user.has_role? :store_stocker
      # can :manage, Store do |store|
      #   store.stockers.include?(user)
      # end

    else
      can :read, Product
      can :read, Order do |order|
        order.user == user
      end
      # can :update, User { |user_to_edit| user_to_edit == user }

    # if user.roles.select{|role| role.name == "site_admin" }.any?
    #   can :manage, :all
    #   can :read, :stores
    # elsif user.roles.select{|role| role.name == "store_admin" }.any?
    #   can :manage, Category
    #   can :update, Order
    #   can :read, :dashboard
    #   can :manage, Product
    # elsif user.roles.select{|role| role.name == "store_stocker"}.any?
    #   can [:read, :create], Product
    #   can [:update, :retire], @product do |product|
    #     user.stores.include?(product.store)
    #   end
    # else
    end
  end
end