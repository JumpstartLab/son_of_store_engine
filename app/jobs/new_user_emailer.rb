class NewUserEmailer
  @queue = :emailer

  def self.perform(email)
    Notification.sign_up_confirmation(email).deliver
  end
end