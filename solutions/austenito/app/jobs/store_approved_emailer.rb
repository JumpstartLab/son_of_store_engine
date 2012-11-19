class StoreApprovedEmailer
  @queue = :emails

  def self.perform(store_id)
    store = Store.find(store_id)
    UserMailer.approved_store_notice(store).deliver
  end
end
