class OrderStatusEmailer
  @queue = :emails

  def self.perform(user_id, order_id, clazz)
    user = eval(clazz).find(user_id)
    order = Order.find(order_id)
    UserMailer.status_confirmation(user, order).deliver
  end
end
