class NewStoreApprovalEmailer
  @queue = :emailer

  def self.perform(store)
    Notification.new_store_approval(store).deliver
  end
end