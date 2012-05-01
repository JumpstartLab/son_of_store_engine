# CanCan

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user
      can :read, Product
      can :read, Order do |order|
        order.user == user
      end
      # can :update, User { |user_to_edit| user_to_edit == user }
    end
  end
end