class Store::Admin::RetirementsController < Store::Admin::BaseController

  def create
    product = Product.find(params[:product_id])
    authorize! :retire, product 

    if product.active?
      product.retire
    else
      product.activate
    end
    redirect_to admin_products_path(current_store.slug)
  end

end