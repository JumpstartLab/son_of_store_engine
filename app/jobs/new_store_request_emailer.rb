class NewStoreRequestEmailer
  @queue = :emailer

  def self.perform(store)
    Notification.new_store_request(store).deliver
  end
end