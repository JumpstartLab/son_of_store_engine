class BackgroundJob
  def self.order_email(user, order)
    Resque.enqueue(OrderEmailer, user, order)
  end

  def self.store_email(store)
    # enqueue store emailer
  end
end