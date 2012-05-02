class NewUserAndStoreRoleEmailer
  @queue = :emailer

  def self.perform(email, store_id, role)
    Notification.new_user_and_store_role(email, store_id, role).deliver
  end
end