module Stores
  module Admin
    class RolesController < BaseController
  
      def new
        authorize! :promote_users?, current_store
        @user = current_store.users.new
      end

      def create
        authorize! :promote_users?, current_store
        if @user = User.find_by_email(params[:user][:email])
          determine_path_and_assign_role(@user)
        else
          #send email
          redirect_to store_admin_path(current_store.slug),
            :notice => "That user does not exist, so we sent them a signup email."
        end
      end

      def destroy
        authorize! :promote_users?, current_store

        @role = Role.find(params[:id])
        if @role.destroy
          redirect_to store_admin_path(current_store.slug)
        else
          redirect_to :back
        end
      end

      def determine_path_and_assign_role(user)
        role = params[:role]
        if role == "store_stocker" || role == "store_admin"
          user.roles.create(name: params[:role], store: current_store)
          redirect_to store_admin_path(current_store.slug), :notice => "#{user.name} is now a #{role.gsub('_',' ')}."
        else
          redirect_to store_admin_path(current_store.slug), :notice => "That roles does not exist."
        end
      end

    end
  end
end