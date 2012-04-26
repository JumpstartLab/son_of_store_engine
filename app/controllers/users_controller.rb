class UsersController < ApplicationController

  before_filter :is_current_user?, only: [ :show ]

  def new
    @user = User.new

    if current_store.nil?
      render 'new_global' and return
    end
  end

  def create
    user_info = params[:user]
    @user = User.new(user_info)
    if @user.save
      cart = current_cart
      if @user = login(user_info[:email], user_info[:password])
        successful_login(cart, @user)
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

  def successful_login(cart_before_login, user)
    if current_store
      if cart_before_login.has_products?
        existing_cart = user.carts.where(:store_id => current_store.id).first
        existing_cart.destroy if existing_cart
        user.carts << cart_before_login
      else
        cart_before_login.destroy
      end
      redirect_to store_path(current_store.slug)
    else
      redirect_to root_path
    end

  end

end
