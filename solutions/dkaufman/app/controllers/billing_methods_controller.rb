class BillingMethodsController < ApplicationController
  include ExtraBillingMethods
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

end
