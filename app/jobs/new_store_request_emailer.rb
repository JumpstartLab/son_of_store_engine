class NewStoreRequestEmailer
  @queue = :emailer

  def self.perform(store_id)
    store = Store.find(store_id)
    admin_user = store.users.first
    mail(:to => admin_user.email, :subject => "New Store Requested")
  end
end