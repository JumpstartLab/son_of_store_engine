class Store::Admin::BaseController < ApplicationController
  def current_ability
    @current_ability ||= AdminAbilityStore.new(current_user)
  end
end