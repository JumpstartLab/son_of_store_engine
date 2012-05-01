class Admin::ProductsController < Admin::ApplicationController
  skip_before_filter :is_admin?
  before_filter :is_stocker_or_admin?

  def index
    @products = store.products.active.paginate(:page => params[:page])
    @retired_products = store.products.retired.paginate(:page => params[:page])
    @categories = store.categories.all
  end

  def new
    @product = Product.new
    @categories = store.categories.all
  end

  def create
    @product = Product.create(params[:product])
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
    @product = Product.find_by_id(params[:id])
    @categories = @product.categories
  end

  def edit
    @product = Product.find(params[:id])
    @categories = Category.all
  end

  def update
    @product = Product.find(params[:id])
    @categories = Category.all
    @product.update_attributes(params[:product])

    if @product.save
      @product.update_categories(params[:categories][1..-1])
      redirect_to admin_product_path(@product),
        notice: 'Product was successfully updated.'
    else
      @product.errors.full_messages.each do |msg|
        flash.now[:error] = msg
      end
      render 'edit'
    end
  end
end
