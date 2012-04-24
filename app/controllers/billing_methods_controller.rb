#
class BillingMethodsController < ApplicationController
  before_filter :load_billing_method, only: [:edit, :update]
  before_filter :validate_billing_user, only: [:edit]

  def index
    redirect_to root_url
  end

  def new
    session[:return_to] = request.referrer
    @billing_method = BillingMethod.new
  end
  def edit
    session[:return_to] = request.referrer
  end

  def show
    redirect_to root_url
  end

  def create
    @billing_method = BillingMethod.new(params[:billing_method])
    try_to_save_billing
  end

  def update
    if @billing_method.update_attributes(params[:billing_method])
      notice = "Billing Address Successfully Saved"
      redirect_to session[:return_to], notice: notice
    else
      notice = 'Please input a valid billing method'
      render :edit
    end
  end

  private

  def try_to_save_billing
    if @billing_method.save
      save_billing
    else
      render :new
    end
  end

  def save_billing
    notice = "Billing Address Successfully Added"
    if logged_in?
      @billing_method.update_attribute(:user_id, current_user.id)
    end
    if session[:order_id]
      order = Order.find(session[:order_id])
      order.update_attribute(:billing_method_id, @billing_method.id)
    end
    redirect_to session[:return_to]
  end

  def load_billing_method
    if logged_in?
      @billing_method = current_user.billing_method
    else
      @billing_method = BillingMethod.find_by_order_id(session[:order_id])
    end
  end
end
