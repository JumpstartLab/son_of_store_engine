module Admin
  class StoresController < Controller
    skip_before_filter :require_store_admin
    before_filter :lookup_store, :only => [
                                            :show, :edit, :update,
                                            :approve, :decline,
                                            :enable, :disable

                                          ]
    before_filter :find_store_from_tenant, :only => [:manage]
    before_filter :verify_store_admin, :except => [:new, :create, :index]
    before_filter :require_admin, :only => [:index]
    cache_sweeper :store_sweeper

    def index
      @stores = Store.where('active <> 0')
    end

    def show
    end

    def edit
    end

    def manage
      render "admin/stores/show"
    end

    def new
      @store = Store.new
    end

    def create
      @store = Store.create_store(params[:store], current_user)
      if @store.save
        Resque.enqueue(NewStoreRequestEmailer, @store.id)
        redirect_to admin_store_path(@store), notice: 'Store created!'
      else
        flash[:alert] = "There was an error while creating your store."
        render action: "new"
      end
    end

    def update
      if @store.update_attributes(params[:store])
        flash[:notice] = "Store was successfully updated."
        redirect_to("http://#{params[:store][:url]}.#{request.domain}" +
          (request.port.nil? ? '' : ":#{request.port}") + "/admin")
      else
        flash[:alert] = "There was an error while updating your store."
        render action: "edit"
      end
    end

    def approve
      @store.approve
      redirect_to admin_stores_path, notice: "#{@store.name} approved!"
    end

    def decline
      @store.decline
      redirect_to admin_stores_path, notice: "#{@store.name} declined!"
    end

    def enable
      @store.enable
      redirect_to admin_stores_path, notice: "#{@store.name} enabled!"
    end

    def disable
      @store.disable
      redirect_to admin_stores_path, notice: "#{@store.name} disabled!"
    end

    private

    def find_store_from_tenant
      @store = current_tenant
    end

    def lookup_store
      @store = Store.find(params[:id])
    end

    def verify_store_admin
      unless current_user.admin? || @store.editable?(current_user)
        flash[:alert] = "Must be an administrator"
        redirect_to root_url
      end
    end

  end
end