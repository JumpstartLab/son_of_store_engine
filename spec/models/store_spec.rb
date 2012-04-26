require 'spec_helper'

describe Store do
end
# == Schema Information
#
# Table name: stores
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  approval_status  :string(255)     default("pending")
#  domain           :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  enabled          :boolean         default(FALSE)
#  description      :text
#  creating_user_id :integer
#

