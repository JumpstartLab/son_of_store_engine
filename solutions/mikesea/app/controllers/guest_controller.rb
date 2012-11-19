class GuestController < ApplicationController
  def new
    @user = User.new(guest: true)
  end

  def create
    @user = User.new(params[:user])
    @user.update_attribute(:name, "guest")
    if @user.save
      redirect_to guest_shipping_path(user_id: @user.id)
    else
      render :new
    end
  end

  def guest_shipping
    @user = User.find(params[:user_id])
    @shipping_detail = @user.shipping_details.new
  end

  def guest_payment
    shipping_detail = ShippingDetail.new(params[:shipping_detail])
    if shipping_detail.save!
      @credit_card = shipping_detail.user.credit_cards.new
    else
      render :guest_shipping
    end
  end

  def guest_order
    credit_card = CreditCard.new(user_id: params[:credit_card][:user_id])
    credit_card.update_attribute(:stripe_card_token, params[:credit_card][:stripe_card_token])
    if credit_card.save
      process_order(credit_card)
      redirect_to order_path(@order)
    else
      render :guest_payment
    end
  end

  def process_order(credit_card)
    @order = Order.build_from_guest_id(credit_card.user_id, current_cart)
    @order.charge_as_guest(current_cart)
    @order.save
    current_cart.destroy
  end
end
