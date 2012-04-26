class NewUserEmailer
  @queue = :emailer

  def self.perform(user_id)
    @user = User.find(user_id)
    Notification.sign_up_confirmation(@user).deliver
  end
end