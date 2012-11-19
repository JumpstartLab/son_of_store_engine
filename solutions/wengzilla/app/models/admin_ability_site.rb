# CanCan file for Site Admin
class AdminAbilitySite
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    if user.has_role? :site_admin
      can :manage, :all
    end
  end
end