# resque for store emails
class StoreEmailer
  @queue = :emails
  def self.perform(method, store_id)
    StoreMailer.send(method.to_sym, store_id).deliver
  end
end