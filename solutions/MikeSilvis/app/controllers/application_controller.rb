# Base class that inherited by all other classes
class ApplicationController < ActionController::Base
  protect_from_forgery

  set_current_tenant_through_filter
  before_filter :find_store, :find_cart, :stripe_api_key
  before_filter :verify_user

  def subdomain_path(sub)
    request.protocol +
    ("#{sub}." if sub).to_s +
    request.domain +
    (request.port.nil? ? '' : ":#{request.port}")
  end

  helper_method :subdomain_path

private

  def find_store
    if request.subdomain.present?
      session[:current_store] = request.subdomain
      current_store = Store.find_store(request.subdomain)
      return redirect_to "/404" if current_store.nil?
      return redirect_to "/maintenance.html" if current_store.disabled?
      set_current_tenant(current_store)
    end
  end

  def stripe_api_key
    Stripe.api_key = ENV['STRIPE_TOKEN'] if Rails.env.to_s == "production"
  end

  include AuthenticationHelpers
  include CartHelpers
end
