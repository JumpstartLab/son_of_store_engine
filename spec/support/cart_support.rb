module CartSupport
  def load_cart_with_products(products)
    products.each do |p|
      visit store_product_path(p.store, p)
      click_link_or_button("Add to Cart")
    end
  end
end

