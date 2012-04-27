# Admins have direct access to administering or creating new admins
class Admin::UsersController < Admin::ApplicationController
  def index
    @users = @store.users.all.sort_by { |user| user.name }
  end

  def show        
  end

  # def show
  #   @categories = @store.categories
  #   @product = @store.products.find(params[:id])
  # end

  # def new
  #   @product = Product.new
  # end

  # def create
  #   product = @store.products.create(params[:product])
  #   flash[:notice] = "Product created."
  #   redirect_to admin_product_path(@store, product)
  # end

  # def edit
  #   @categories = @store.categories.all
  #   @product = @store.products.find(params[:id])
  # end

  # def update
  #   Product.find(params[:id]).update_attributes(params[:product])
  #   redirect_to admin_products_path
  # end

  # def retire_product
  #   product = Product.find(params[:product_id])
  #   product.retire
  #   notice = "Product #{product.title} retired."
  #   redirect_to admin_products_path(@store), :notice => notice
  # end
end
