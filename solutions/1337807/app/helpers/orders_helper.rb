module OrdersHelper
  def permalink(order)
    tracking_url(order.slug)
  end
end
