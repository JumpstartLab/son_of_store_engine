# CanCan

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role? :site_admin
      can :manage, "admin/stores"
      can :read, "admin/stores"
      can :edit, "admin/stores"
    elsif user.has_role? :store_admin
      cannot :read, "admin/stores"
      can :manage, "store/admin/dashboard"
    elsif user.has_role? :store_stocker
      can :read, :all
    else
      can :read, Product
      can :read, Order do |order|
        order.user == user
      end
      # can :update, User { |user_to_edit| user_to_edit == user }
    end
  end
end