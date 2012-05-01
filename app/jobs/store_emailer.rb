class StoreEmailer
  @queue = :emails
  def self.perform(method, store_id)
    StoreMailer.delayed.send(method.to_sym, store_id).deliver
  end
end