class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new

    if user.has_role? :site_admin
      can :manage, "admin/stores"
    elsif user.has_role? :store_admin
      can :manage, "store/admin/categories"
      can :manage, "store/admin/orders"
      can :manage, "store/admin/products"
      can :manage, "store/admin/statuses"
      can :manage, "store/admin/dashboard", Store
      can :read, "store/admin/dashboard", Store
    elsif user.has_role? :store_stocker
      can :read, :all
      can :manage, "store/admin/products"
      can :manage, "store/admin/retirements"
      can :manage, "store/admin/products"
      can :create, Product do |product|
        product.store == user.store
      end
    else
      can :read, Product
      can :read, Order do |order|
        order.user == user
      end
      # can :update, User { |user_to_edit| user_to_edit == user }
    end
  end
end
