class Admin::ProductsController < Admin::ApplicationController
  skip_before_filter :is_store_admin
  before_filter :is_stocker_or_admin

  def index
    @products = store.products.active.page(params[:page]).per(12)
    @retired_products = store.products.retired.page(params[:page]).per(12)
    @categories = store.categories.all
  end

  def new
    @product = store.products.new
    @categories = store.categories.all
  end

  def create
    @product = store.products.create(params[:product])
    @categories = @product.categories

    if @product.save
      @product.update_categories(params[:categories][1..-1])
      redirect_to admin_products_path,
        notice: 'Product was successfully created.'
    else
      @product.errors.full_messages.each do |msg|
        flash.now[:error] = msg
      end
      render 'new'
    end
  end

  def show
    @product = store.products.find_by_id(params[:id])
    @categories = @product.categories
  end

  def edit
    @product = store.products.find(params[:id])
    @categories = store.categories.all
  end

  def update
    @product = store.products.find(params[:id])
    @categories = store.categories.all
    if @product.update_attributes(params[:product])
      @product.update_categories(params[:categories][1..-1])
      redirect_to admin_products_path(subdomain: store.url_name),
        notice: 'Product was successfully updated.'
    else
      @product.errors.full_messages.each do |msg|
        flash.now[:error] = msg
      end
      render 'edit'
    end
  end

  private

  def is_stocker_or_admin
    redirect_to store_path(subdomain: store.url_name) unless
      store.users.include?(current_user) || current_user.admin
  end
end
