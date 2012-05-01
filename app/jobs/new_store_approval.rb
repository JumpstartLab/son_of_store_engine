class NewStoreApprovalEmailer
  @queue = :emailer

  def self.perform(store_id)
    Notification.new_store_approval(store_id).deliver
  end
end