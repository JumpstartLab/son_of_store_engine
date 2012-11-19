module ProductsActions
  def index
    ordering = "updated_at DESC"
    @products = Product.where(:active => 1).order(ordering).page(params[:page])
    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
  end
end