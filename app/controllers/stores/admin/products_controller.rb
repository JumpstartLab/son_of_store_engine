# the wrapper for the store_slugs
module Stores
  # the module for store-specific admins
  module Admin
    # for controlling products
    class ProductsController < BaseController
      helper_method :product, :products

      before_filter :can_manage_store_products

      def index
        @retired_products = current_store.retired_products
        @categories = current_store.categories
      end

      def new
        @categories = current_store.categories
      end

      def create
        if product.save
          product.update_categories(params[:categories][1..-1])
          redirect_to store_admin_products_path(current_store.slug),
            notice: 'Product was successfully created.'
        else
          flash.now[:error] = product.errors.full_messages.join("\n")
          render 'new'
        end
      end

      def show
        @categories = product.categories
      end

      def edit
      end

      def update
        @categories = current_store.categories.all
        product.update_attributes(params[:product])

        if product.save
          product.update_categories(params[:categories][1..-1])
          redirect_to store_admin_products_path(current_store.slug),
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
          @product ||= current_store.products.where(id: params[:product_id] ||
                                                        params[:id]).first
        else
          @product ||= current_store.products.build(params[:product])
        end
      end

      def products
        @products = current_store.active_products.order("name").page(params[:page]).per(12)
      end

      def can_manage_store_products
        authorize! :read, current_store
        # authorize! :manage, :products
      end
    end
  end
end