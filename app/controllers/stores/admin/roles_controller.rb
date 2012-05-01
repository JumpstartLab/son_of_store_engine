module Stores
  module Admin
    class RolesController < BaseController
  
      def destroy
        @role = Role.find(params[:id])
        raise @role.inspect
        if @role.destroy
          redirect_to admin_path(current_store.slug)
        else
          redirect_to :back
        end
      end
    end
  end
end