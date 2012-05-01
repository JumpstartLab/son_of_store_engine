module ProductsActions
  def index
    @products = Product.where(:active => 1).paginate(:page => params[:page])
    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
  end
end