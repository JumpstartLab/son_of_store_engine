class UsersController < ApplicationController
  before_filter { @cart = find_or_create_cart_from_session }

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

  end

  private

  def find_or_create_cart_from_session
    cart = Cart.find_by_id(session[:cart_id])
    cart ||= Cart.create(:user => current_user)
    session[:cart_id] = cart.id
    cart
  end

end
