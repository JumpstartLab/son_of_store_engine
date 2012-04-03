class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:message] = "Signup successful, #{@user.name}! Now buy things!"
      redirect_to user_path(@user)
    else
      flash[:message] = "We were unable to complete your request at this time."
      redirect_to new_user_path
    end
  end
  def show
    @user = User.find_by_id(params[:id])
  end
end
