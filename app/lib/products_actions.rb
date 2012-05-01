module ProductsActions
  def index
    @products = Product.where(:active => 1).page(params[:page])
    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
  end
end