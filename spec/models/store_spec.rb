# == Schema Information
#
# Table name: stores
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  user_id    :integer
#  permalink  :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Store do
  pending "add some examples to (or delete) #{__FILE__}"
end
