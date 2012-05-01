class AdminAbilityStore
  include CanCan::Ability
  def initialize(user)

    user ||= User.new
    if user.has_role? :site_admin
      can [:manage, :read], Store
    else
      cannot [:manage, :read], Store
    end
  end
end