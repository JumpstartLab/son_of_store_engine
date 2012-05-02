class OrderEmailer
  @queue = :emails
  def self.perform(method, order_id)
    OrderMailer.send(method.to_sym, order_id).deliver
  end

end