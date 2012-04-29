class Admin::ProductsController < ApplicationController
  before_filter :require_login
  before_filter :is_admin?

  helper_method :product

  def index
    @retired_products = current_store.products.retired
    @categories = current_store.categories
  end

  def new
    @categories = current_store.categories
  end

  def create
    if product.save
      product.update_categories(params[:categories][1..-1])
      redirect_to admin_product_path(current_store.slug, product.id),
        notice: 'Product was successfully created.'
    else
      flash.now[:error] = current_store.product.errors.full_messages.join("\n")
      render 'new'
    end
  end

  def show
    @categories = product.categories
  end

  def edit
    @categories = current_store.categories
  end

  def update
    @categories = current_store.categories.all
    product.update_attributes(params[:product])

    if product.save
      product.update_categories(params[:categories][1..-1])
      redirect_to admin_product_path(current_store.slug, product.id),
        notice: 'Product was successfully updated.'
    else
      product.errors.full_messages.each do |msg|
        flash.now[:error] = msg
      end
      render 'edit'
    end
  end

private
  def product
    if params[:product_id] || params[:id]
      @product ||= current_store.products.where(id: params[:product_id] || params[:id]).first
    else
      @product ||=current_store.products.build(params[:product])
    end
  end

  def products
    @products = current_store.products.active
  end

end
