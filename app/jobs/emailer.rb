class Emailer
  @queue = :emails
  def self.perform(method, store_id)
    # possibly long-running code to send the email
    #

    # TODO: ask Jeff how this line works
    StoreMailer.send(method.to_sym, store_id).deliver
  end
end