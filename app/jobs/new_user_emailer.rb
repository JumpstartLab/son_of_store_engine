class NewUserEmailer
  @queue = :emailer

  def self.perform(user_id)
    user = User.find(user_id)
    mail(:to => user.email, :subject => "Welcome #{user.name}")
  end
end