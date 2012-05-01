class UserEmailer
  @queue = :emails
  def self.perform(method, email)
    UserMailer.send(method.to_sym, user).deliver
  end
end