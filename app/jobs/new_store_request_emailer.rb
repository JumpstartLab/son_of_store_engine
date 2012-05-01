class NewStoreRequestEmailer
  @queue = :emailer

  def self.perform(store_id)
    Notification.new_store_request(store_id).deliver
  end
end