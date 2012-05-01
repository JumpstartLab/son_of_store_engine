class AdminAbilityStore
  include CanCan::Ability
  
  def initialize(user)

    user ||= User.new

    if user.has_role?("site_admin")
      can :manage, :all
    else
      can [:manage, :promote_users], Store do |store|
        user.has_role?("store_admin", store)
      end

      can [:manage], Product do |product|
        user.has_role?("store_stocker", product.store) || user.has_role?("store_admin", product.store)
      end



    end
  end
end
    # elsif user.has_role? :store_stocker

    #   can [:read], Store do |store|
    #     store.stockers.include?(user)
    #   end

    #   can [:manage], Product do |product|
    #     product.store.stockers.include?(user)
    #   end

    # else
    #   can :read, Product
    #   can :read, Order do |order|
    #     order.user == user
    #   end
    #   can :update, User { |user_to_edit| user_to_edit == user }
    # end
