class NewStoreApprovalEmailer
  @queue = :emailer

  def self.perform(store_id)
    @store = Store.find(store_id)
    Notification.new_store_approval(@store).deliver
  end
end