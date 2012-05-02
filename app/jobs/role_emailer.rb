class RoleEmailer
  @queue = :emails
  def self.perform(method, user_id)
    RoleMailer.send(method.to_sym, user_id).deliver
  end
end