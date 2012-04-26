class OrderEmailer
  @queue = :emails
  def self.perform(user, order)
    UserMailer.order_confirmation(order_user, self).deliver
  end
end