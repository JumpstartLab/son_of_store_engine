class NewUserAndStoreRoleEmailer
  @queue = :emailer

  def self.perform(email, store_id, role)
    Notification.new_store_role(email, store_id, role).deliver
  end
end