class UsersController < ApplicationController
  before_filter :is_current_user?, only: [ :show ]

  def new
    @user = User.new
  end

  def create
    user_info = params[:user]
    @user = User.new(user_info)
    if @user.save
      @user.confirm_signup
      cart = current_cart
      if user = login(user_info[:email], user_info[:password])
        successful_login(cart, user)
      end
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @orders = current_user.recent_orders.desc
  end

  private
  def is_current_user?
    redirect_to_last_page unless User.find_by_id(params[:id]) == current_user
  end

  def successful_login(cart, user)
    cart.assign_cart_to_user(user)
    flash[:message] = "Sign-up complete! You're now logged in!"
    redirect_to session[:last_page] || root_path
  end
end
