class AddressChecker
  def self.validate(street, zipcode)
    Geocoder.search("#{street}, #{zipcode}").first
  end
end