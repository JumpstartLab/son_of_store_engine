class OrderEmailer
  @queue = :emails
  def self.perform(method, user_id)
    OrderMailer.send(method.to_sym, user_id).deliver
  end

end