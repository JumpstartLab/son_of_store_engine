class CheckAddress
  @queue = :address

  def self.perform(user_id, street, zipcode)
    user_for_address = User.find(user_id)
    user_for_address.update_address(street, zipcode)
  end
end