# Base class that inherited by all other classes
class ApplicationController < ActionController::Base
  protect_from_forgery

  set_current_tenant_through_filter
  before_filter :find_store, :find_cart, :stripe_api_key
  before_filter :verify_user

private

  def find_store
    unless request.subdomain.empty?
      current_store = Store.find_active_store(request.subdomain)
      redirect_to "/404" if current_store.nil?
      set_current_tenant(current_store)
    end
  end

  def stripe_api_key
    Stripe.api_key = ENV['STRIPE_TOKEN'] if Rails.env.to_s == "production"
  end

  include AuthenticationHelpers
  include CartHelpers
end
