module Admin
  class StoreRolesController < Controller
    def new
      @store_role = current_tenant.store_roles.new
    end

    def create
      @store_role = current_tenant.store_roles.new
      @store_role.new_user(params[:store_role])
      redirect_to '/admin', notice: "Admin added."
    end

    def destroy
      sr = current_tenant.store_roles.find(params[:id])
      sr.remove_role
      redirect_to '/admin', notice: "Stocker removed."
    end
  end
end