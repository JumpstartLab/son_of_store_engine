module Stores
  module Admin
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