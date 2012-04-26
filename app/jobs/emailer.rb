class Emailer
  @queue = :emails
  def self.perform(to, subject, body)
    # possibly long-running code to send the email
    #

    $redis.set 'emailer', Store.emailer
  end
end