module Admin
  class StoresController < ApplicationController
    
    before_filter :authorize_site_admin!

    def current_ability
      @current_ability ||= AdminAbilitySite.new(current_user)
    end

    def index
      @stores = Store.where("status = 'approved'
        OR status = 'disabled'
        OR status = 'pending'")
    end

    def edit
      @store = Store.find(params[:id])
    end

    def update
      @store = Store.find(params[:id])
      @store.update_status(params[:store])
      if @store.save
        @store.notify_store_admin_of_status
        message = "Store has been #{@store.status}.
         An email has been sent to #{@store.users.first.email}"
      else
        message = "There has been an error in updating status."
      end
      flash.notice = message
      redirect_to admin_stores_path
    end

    def show
      @store = Store.find(params[:id])
    end

    private

    def authorize_site_admin!
      authorize! :manage, :all
    end

  end
end
