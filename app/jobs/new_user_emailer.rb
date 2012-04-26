class NewUserEmailer
  @queue = :emailer

  def self.perform(user)
    @user = user
    Notification.sign_up_confirmation(@user).deliver
  end
end