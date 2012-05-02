# the wrapper for the store_slugs
module Stores
  # the module for store-specific admins
  module Admin
    # for admin to control the categories
    class CategoriesController < BaseController

      before_filter :authorize_store_admin!

      def new
        @category = Category.new
      end

      def show
        @category = current_store.categories.find(params[:id])
        @products = @category.products
      end

      def create
        if @category = current_store.categories.create(params[:category])
          redirect_to store_admin_products_path,
          notice: 'Category was successfully created.'
        else
          @category.errors.full_messages.each do |msg|
            flash.now[:error] = msg
          end
          render 'new'
        end
      end

      def edit
        @category = current_store.categories.find(params[:id])
      end

      def update
        @category = current_store.categories.find(params[:id])
        @category.update_attributes(params[:category])

        if @category.save
          redirect_to store_admin_products_path,
            notice: 'Category was successfully updated.'
        else
          @category.errors.full_messages.each do |msg|
            flash.now[:error] = msg
          end
          render 'edit'
        end
      end
    end
  end
end