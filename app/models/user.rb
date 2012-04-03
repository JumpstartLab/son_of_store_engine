class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :password, :name

  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
end
