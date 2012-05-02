module Stores
  module Admin
    class RolesController < BaseController
      before_filter :authorize_store_admin!
  
      def new
        authorize! :promote_users, current_store
        @user = current_store.users.new
      end

      def create
        authorize! :promote_users, current_store
        if @user = User.find_by_email(params[:user][:email])
          assign_role(@user)
        else
          new_user_email = params[:user][:email]
          Resque.enqueue(UserEmailer, "signup_notification", new_user_email)
          redirect_to store_admin_path(current_store.slug),
            :notice => "That user does not exist. A signup email has been sent."
        end
      end

      def destroy
        authorize! :promote_users, current_store
        @role = current_store.roles.find(params[:id])

        if (@role.name == "store_admin" && current_store.has_multiple_admin?) || @role.name == "store_stocker"
          @role.destroy
          @role.user.notify_of_role_removal(@role)
          redirect_to store_admin_path(current_store.slug), :notice => 'Role has been removed'
        else
          redirect_to :back, :notice => 'Unable to demote user. Store must have at least one admin.'
        end
      end

      def assign_role(user)
        role = params[:role]
        if user.promote_to(role, current_store)
          message = "#{user.name} is now a #{role.gsub('_',' ')}."
          user.notify_of_role_addition(role)
        else
          message = "#{user.name} cannot be a #{role.gsub('_',' ')}."
        end
        redirect_to store_admin_path(current_store.slug), :notice => message
      end

    end
  end
end