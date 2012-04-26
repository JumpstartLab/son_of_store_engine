class NewUserEmailer
  @queue = :emailer

  def self.perform(email, name)
    @email  = email
    @name   = name
    Notification.sign_up_confirmation(@email,@name).deliver
  end
end