module Admin
  class StoresController < Controller

    def index
      @stores = Store.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @stores }
      end
    end

    def show
      @store = Store.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @store }
      end
    end

    def new
      @store = Store.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @store }
      end
    end

    def edit
      @store = Store.find(params[:id])
    end


    def create
      @store = Store.new(params[:store])

      respond_to do |format|
        if @store.save
          format.html { redirect_to admin_store_path(@store), notice: 'Store was successfully created.' }
          format.json { render json: @store, status: :created, location: @store }
        else
          format.html { render action: "new" }
          format.json { render json: @store.errors, status: :unprocessable_entity }
        end
      end
    end


    def update
      @store = Store.find(params[:id])

      respond_to do |format|
        if @store.update_attributes(params[:store])
          format.html { redirect_to admin_store_path(@store), notice: 'Store was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @store.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @store = Store.find(params[:id])
      @store.destroy

      respond_to do |format|
        format.html { redirect_to admin_stores_url }
        format.json { head :no_content }
      end
    end

    def approve
      @store = Store.find(params[:id])
      @store.update_attribute(:status, "approved")
      redirect_to admin_stores_path, notice: "#{@store.name} Successfully Approved"
    end

    def decline
      @store = Store.find(params[:id])
      @store.update_attribute(:status, "declined")
      redirect_to admin_stores_path, notice: "#{@store.name} Successfully Declined"
    end

  end
end