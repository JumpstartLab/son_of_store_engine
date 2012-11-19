class UserConfirmationEmailer
  @queue = :emails

  def self.perform(user)
    UserMailer.user_confirmation(user).deliver
  end
end
