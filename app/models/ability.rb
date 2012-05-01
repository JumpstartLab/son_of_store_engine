# CanCan

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    raise "BOOM"

    if user.has_role? :site_admin
      can :manage, :all
      #can :read, "admin/stores"

    elsif user.has_role? :store_admin
      can :edit, Store do |store|
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
    end

  end
end