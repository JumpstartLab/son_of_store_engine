class NewUserEmailer
  @queue = :emailer

  def self.perform(email)
    raise "MEH"
    Notification.sign_up_confirmation(email).deliver
  end
end