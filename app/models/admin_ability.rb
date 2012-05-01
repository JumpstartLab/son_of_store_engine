# class AdminAbility
#   include CanCan::Ability
#   def initialize(user)

#     user ||= User.new

#     if user.roles.select{|role| role.name == "site_admin" }.any?
#       can :manage, :all
#       can :read, :stores
#     elsif user.roles.select{|role| role.name == "store_admin" }.any?
#       can :manage, Category
#       can :update, Order
#       can :read, :dashboard
#       can :manage, Product
#     elsif user.roles.select{|role| role.name == "store_stocker"}.any?
#       can [:read, :create], Product
#       can [:update, :retire], @product do |product|
#         user.stores.include?(product.store)
#       end
#     else
#       #guest user can't gain access to admin functionality
#     end
#   end
# end