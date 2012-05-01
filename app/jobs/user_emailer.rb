class UserEmailer
  @queue = :emails
  def self.perform(method, email)
    UserMailer.send(method.to_sym, email).deliver
  end
end