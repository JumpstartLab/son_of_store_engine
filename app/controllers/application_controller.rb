# Base class that inherited by all other classes
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :find_cart, :verify_user

  include AuthenticationHelpers
  include CartHelpers
end
