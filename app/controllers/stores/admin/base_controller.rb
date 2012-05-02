# the wrapper for the store_slugs
module Stores
  # the module for store-specific admins
  module Admin
    # define current_ability for store_admin
    class BaseController < ApplicationController
      def current_ability
        @current_ability ||= AdminAbilityStore.new(current_user)
      end

      def authorize_store_admin!
        authorize! :manage, current_store
      end

    end
  end
end