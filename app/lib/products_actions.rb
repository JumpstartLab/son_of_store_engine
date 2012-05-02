module ProductsActions
  def index
    o = "updated_at DESC"
    @products = Product.where(:active => 1).order(o).page(params[:page])
    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
  end
end