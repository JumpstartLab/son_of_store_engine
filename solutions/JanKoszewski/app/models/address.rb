# == Schema Information
#
# Table name: addresses
#
#  id         :integer         not null, primary key
#  street     :string(255)
#  city       :string(255)
#  state      :string(255)
#  zipcode    :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

# Users can have billing or shipping addresses
class Address < ActiveRecord::Base
  attr_accessible :city, :state, :street, :zipcode, :user_id

  def self.create_multiple(addresses)
    addresses.each do |address|
      create(address) unless address[:street].blank?
    end
  end
end
