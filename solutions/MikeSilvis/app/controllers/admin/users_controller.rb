# Allows creating and modifying users
module Admin
  class UsersController < Controller
    cache_sweeper :user_sweeper

    def index
      @users = User.page(params[:page])
    end

    def destroy
      User.find(params[:id]).destroy
      redirect_to admin_users_path
    end
  end
end