require 'spec_helper'

describe User do
end
# == Schema Information
#
# Table name: users
#
#  id                              :integer         not null, primary key
#  email                           :string(255)
#  crypted_password                :string(255)
#  salt                            :string(255)
#  is_admin                        :boolean         default(FALSE)
#  name                            :string(255)
#  created_at                      :datetime        not null
#  updated_at                      :datetime        not null
#  reset_password_token            :string(255)
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  remember_me_token               :string(255)
#  remember_me_token_expires_at    :datetime
#  display_name                    :string(255)
#

