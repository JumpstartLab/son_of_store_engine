module Stores
  module Admin
    class StoresController < BaseController
      before_filter :authorize_store_admin!

      def edit
        @store = current_store
      end

      def update
        if params[:new_slug] == current_store.slug || params[:confirm].present?
          current_store.update_attributes( name: params[:name],
                                           description: params[:description],
                                           slug: params[:new_slug])
          redirect_to store_admin_path(current_store.slug), :notice => "Store details updated."
        else
          warn_on_update_slug
          @store = current_store
          @store.attributes = { "name"        => params[:name],
                                "description" => params[:description],
                                "slug"        => params[:new_slug] }
          @confirm = true
          render 'edit'
        end
      end

      private

      def warn_on_update_slug
        confirm_link = "<a class='submit' href='#'>Confirm</a>" 
        cancel_link = "<a href=\"#{edit_store_admin_store_path(current_store.slug)}\">Cancel</a>" 
        flash.now.alert = "Are you sure you want to change the store URL for #{current_store.name}?
          This action could break external links to #{current_store.name}. #{confirm_link} | #{cancel_link}".html_safe
      end

    end
  end
end