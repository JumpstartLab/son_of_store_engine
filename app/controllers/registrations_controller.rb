# This overrides the Devise controller, allowing us to update roles for users.
class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
  end

  def update
    user = User.find_by_email(params[:user][:email])
    roles = params[:user][:roles]
    params[:user].delete(:roles)

    roles.each do |role_id, role_val|
      user.roles << Role.find(role_id) if role_val == '1'
    end

    super
  end
end
