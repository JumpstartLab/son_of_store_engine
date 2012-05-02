class TerminationEmailer
  @queue = :emails

  def self.perform(user)
    UserMailer.termination_notice(user).deliver
  end
end