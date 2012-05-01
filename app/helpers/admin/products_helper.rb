module Admin::ProductsHelper

  def retire_button(product)
    if product.active?
      link_to('Retire product', 
        product_retirement_path(product),
        :class => "btn btn-danger",
        method: :post)
    elsif !product.active?
      link_to('Un-retire product', 
        product_retirement_path(product),
        :class => "btn btn-danger",
        method: :put)
    end
  end
end
