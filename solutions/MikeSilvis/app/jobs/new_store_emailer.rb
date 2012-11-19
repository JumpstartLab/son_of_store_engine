class NewStoreEmailer
  @queue = :emailer

  def self.perform(user)
    Notification.new_store_emailer(user).deliver
  end
end