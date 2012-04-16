class Search < ActiveRecord::Base
  attr_accessible :products, :orders
end
# == Schema Information
#
# Table name: searches
#
#  id         :integer         not null, primary key
#  products   :string(255)
#  orders     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

