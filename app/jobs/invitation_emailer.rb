class InvitationEmailer
  @queue = :emails

  def self.perform(email, privilege, store)
    UserMailer.invitation(email, privilege, store).deliver
  end
end