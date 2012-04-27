class BackgroundJob
  def self.order_email(user, order)
    Resque.enqueue(OrderEmailer, user.id, order.id, user.class.to_s)
  end

  def self.store_email(store)
    # enqueue store emailer
  end
end