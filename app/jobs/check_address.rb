class CheckAddress
  @queue = :address

  def self.perform(user_id, street, zipcode)
    u = User.find(user_id)
    u.update_address(street, zipcode)
  end
end