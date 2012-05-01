class Admin::CategoriesController < Admin::ApplicationController
  before_filter :require_login
  before_filter :is_admin?

  def new
    @category = store.categories.new
  end

  def index
    @categories = store.categories
  end

  def show
    @category = store.categories.find(params[:id])
    @products = @category.products
  end

  def create
    @category = store.categories.create(params[:category])

    if @category.save
      redirect_to admin_dashboard_path,
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
      redirect_to admin_categories_path(store),
        notice: 'Category was successfully updated.'
    else
      @category.errors.full_messages.each do |msg|
        flash.now[:error] = msg
      end
      render 'edit'
    end
  end

end
