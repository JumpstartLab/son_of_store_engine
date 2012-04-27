class OrderEmailer
  @queue = :emails

  def self.perform(user_id, order_id, clazz)
    user = eval(clazz).find(user_id)
    # user = clazz.send(:find, user_id)
    order = Order.find(order_id)
    UserMailer.order_confirmation(user, order).deliver
  end
end