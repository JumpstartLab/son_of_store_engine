class NewUserEmailer
  @queue = :emailer

  def self.perform(user)
    @email  = user[:email]
    @name   = user[:name]
    Notification.sign_up_confirmation(@email,@name).deliver
  end
end