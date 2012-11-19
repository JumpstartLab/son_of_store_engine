class NewOrderEmailer
  @queue = :emailer

  def self.perform(order)
    Notification.order_email(order).deliver
  end
end