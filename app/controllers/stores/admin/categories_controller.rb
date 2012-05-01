module Stores
  module Admin
    class CategoriesController < BaseController

      before_filter :authorize_store_admin!

      def new
        authorize! :manage, current_store

        @category = Category.new
      end

      def show
        authorize! :manage, current_store

        @category = Category.find(params[:id])
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
        @category = Category.find(params[:id])
      end

      def update
        @category = Category.find(params[:id])
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

      private



    end
  end
end