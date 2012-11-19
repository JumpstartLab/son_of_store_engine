class ShippingAddressesController < ApplicationController
  include ExtraShippingMethods
  before_filter :load_shipping_address, only: [:edit, :update]
  before_filter :validate_shipping_user, only: [:edit]

  def index
    redirect_to root_url
  end

  def new
    session[:return_to] = request.referrer
    @shipping_address = ShippingAddress.new
  end

  def edit
    session[:return_to] = request.referrer
  end

  def show
    redirect_to root_url
  end

  def create
    @shipping_address = ShippingAddress.new(params[:shipping_address])
    try_to_save_shipping
  end

  def update
    if @shipping_address.update_attributes(params[:shipping_address])
      notice = "Shipping Address Successfully Saved"
      redirect_to session[:return_to], notice: notice
    else
      notice = 'Please input a valid shipping address'
      render :edit
    end
  end

end
