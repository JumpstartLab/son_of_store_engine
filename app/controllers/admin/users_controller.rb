# Allows creating and modifying users
module Admin
  class UsersController < Controller
    def index
      @users = User.all
    end

    def destroy
      User.find(params[:id]).destroy
      redirect_to admin_users_path
    end
  end
end