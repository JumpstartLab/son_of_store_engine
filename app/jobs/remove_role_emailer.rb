class RemoveRoleEmailer
  @queue = :emailer

  def self.perform(email, store_id)
    Notification.remove_role(email,store_id).deliver
  end
end