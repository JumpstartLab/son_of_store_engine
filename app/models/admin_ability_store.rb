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

      can :read, Store do |store|
        user.has_role?("store_stocker", store)
      end

      can [:manage,:retire], Product do |product|
        user.has_role?(["store_stocker", "store_admin"], product.store)
      end
    end
  end
end