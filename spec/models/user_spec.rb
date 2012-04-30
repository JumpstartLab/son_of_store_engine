# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  username               :string(255)
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

require 'spec_helper'

describe User do
  let(:user) { Fabricate :user }

  it "can't be created with a blank name" do
    user.name = ""
    user.should_not be_valid
  end

  it "can't be created without an email address" do
    user.email = ""
    user.should_not be_valid
  end

  it "can't be created without a unique email address" do
    user
    meguser = User.new(:name => "Meg",
      :email => "peter.griffin@livingsocial.com",
      :username => "unloved")
    meguser.should_not be_valid
  end

  it "can't be created with an invalid username" do
    user.username = "a"
    user.should_not be_valid
  end

  it "can be created without a username" do
    user.username = nil
    user.should be_valid
  end
end
