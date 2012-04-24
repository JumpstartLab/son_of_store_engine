# Allows creating and modifying users
module StoreAdmin
  class UsersController < Controller

    def index
      @users = User.all
    end

    def destroy
      User.find(params[:id]).destroy
      redirect_to users_path
    end
    
  end
end