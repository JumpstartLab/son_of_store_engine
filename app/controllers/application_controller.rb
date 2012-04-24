# Base class that inherited by all other classes
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :find_cart, :verify_user, :stripe_api_key

  include authentication_helpers
  include cart_helpers

private

  def stripe_api_key
    Stripe.api_key = ENV['STRIPE_TOKEN'] if Rails.env.to_s == "production"
  end

end
