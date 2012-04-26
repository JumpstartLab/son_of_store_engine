class OrderEmailer
  @queue = :emails
  def self.perform(user, order)
    UserMailer.order_confirmation(user, order).deliver
  end
end