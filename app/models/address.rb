# Address object w/ city, state, zip, etc -- uses geocoder gem
class Address < ActiveRecord::Base
  attr_accessible :street, :zipcode
  before_validation :check_address
  belongs_to :user
  belongs_to :order

  validates_presence_of :state

  def check_address
    validated_address = AddressChecker.validate(street, zipcode)
    update_with(validated_address) if validated_address
  end

  def update_with(validated_address)
    self.state = validated_address.state
    self.country = validated_address.country
    self.formatted_address = validated_address.address
  end
end
