class StoreDeclinedEmailer
  @queue = :emails

  def self.perform(user_id, store_name, store_description, 
                   store_slug)
    user = User.find(user_id)
    UserMailer.declined_store_notice(user, store_name, store_description, 
                                     store_slug).deliver
  end
end
