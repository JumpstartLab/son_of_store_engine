class AdminAbilitySite
  include CanCan::Ability
  def initialize(user)

    user ||= User.new
    if user.has_role? :site_admin
      can [:manage, :read], :all
    else
      cannot [:manage, :read], :all
    end
  end
end