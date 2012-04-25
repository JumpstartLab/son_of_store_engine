# == Schema Information
#
# Table name: stores
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  store_unique_id :string(255)
#  description     :string(255)
#  status          :string(255)     default("pending")
#  user_id         :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

require 'spec_helper'

describe Store do
  pending "add some examples to (or delete) #{__FILE__}"
end
