require 'ostruct'

class AddressChecker
  def self.validate(street, zipcode)
    if zipcode =~ /^200/
      OpenStruct.new(:state => "District of Columbia", 
                     :address => "123 First Street")
    else
      nil
    end
  end
end