class NewUserEmailer
  @queue = :emailer

  def self.perform(id)
    @user = User.find(id)
    Notification.sign_up_confirmation(@user).deliver
  end
end