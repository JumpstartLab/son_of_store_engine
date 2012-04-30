class BackgroundJob
  def self.order_email(user, order)
    Resque.enqueue(OrderEmailer, user.id, order.id, user.class.to_s)
  end

  def self.order_status_email(user, order)
    Resque.enqueue(OrderStatusEmailer, user.id, order.id, user.class.to_s)
  end

  def self.store_approved_email(store)
    Resque.enqueue(StoreApprovedEmailer, store.id)
  end

  def self.store_declined_email(store)
    Resque.enqueue(StoreDeclinedEmailer, store.owner.id, store.name, 
                   store.description, store.slug)
  end
end
