# Allows restful actions for the cart
class CartsController < ApplicationController

  def update
    @cart.add_product(params[:product_id])
    redirect_to cart_path, :notice => "Product added to cart" if @cart.save
  end

  def two_click
    @cart.add_product(params[:product_id])
    if @cart.save
        order = Order.charge_two_click(@cart.id)
        session["cart_#{request.subdomain}"] = nil
        redirect_to order_path(order),
          :notice => "Congrats on giving us your money"
    end
  end

  def show
  end

  def destroy
    @cart.remove_product(params[:product_id])
    redirect_to cart_path, :notice => "Product deleted."
  end

  def checkout

  end
  
  def update_quantity
    @cart.update_quantity(params[:cart][:order_products_attributes])
    if @cart.save
      redirect_to cart_path, :notice => "Cart updated successfully"
    else
      flash[:error] = "Your cart was not updated."
      redirect_to cart_path
    end
  end

  def guest
    guest_user = User.create(:guest => true)
    @cart.user = guest_user
    @cart.save
    redirect_to new_order_path
  end

end
