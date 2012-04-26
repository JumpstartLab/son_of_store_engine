module Admin
  class StoresController < Controller  
    def index
      @stores = Store.all
    end

    def show
      @store = Store.find(params[:id])
    end

    def new
      @store = Store.new
    end

    def edit
      @store = Store.find(params[:id])
    end

    def create
      @store = Store.new(params[:store])
      if @store.save
        redirect_to admin_store_path(@store), notice: 'Store was successfully created.'
      else
        render action: "new"
      end
    end
    
    def update
      @store = Store.find(params[:id])  
      if @store.update_attributes(params[:store])
        redirect_to admin_store_path(@store), notice: 'Store was successfully updated.'
      else  
        render action: "edit"
      end
    end

    def destroy
      @store = Store.find(params[:id])
      @store.destroy
      redirect_to admin_stores_path
    end
  end
end