class AddressChecker
  @queue = :geocoder

  def self.perform(street, zipcode)
    AddressChecker.validate(street, zipcode)
  end
  
end