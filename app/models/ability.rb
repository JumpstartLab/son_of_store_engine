# general CanCan file
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user
      can :manage, :all
      # more restrictions in the admin ability files
    end
  end
end