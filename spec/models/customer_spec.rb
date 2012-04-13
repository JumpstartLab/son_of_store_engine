require 'spec_helper'

describe Customer do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: customers
#
#  id                    :integer         not null, primary key
#  stripe_token          :string(255)
#  user_id               :integer
#  ship_address          :string(255)
#  ship_address2         :string(255)
#  ship_state            :string(255)
#  ship_zipcode          :string(255)
#  ship_city             :string(255)
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  stripe_customer_token :string(255)
#

