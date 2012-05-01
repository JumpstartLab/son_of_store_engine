class Admin::BaseController < ApplicationController
  def current_ability
    @current_ability ||= AdminAbilitySite.new(current_user)
  end
end