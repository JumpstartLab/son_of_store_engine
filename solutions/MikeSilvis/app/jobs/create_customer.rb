class CreateCustomer
  @queue = :stripe

  def self.perform(user_id, token)
    BillingProcessor.create_customer(user_id, token)
  end
end