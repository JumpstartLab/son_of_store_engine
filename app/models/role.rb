class Role < ActiveRecord::Base
  TYPES = %w{ store_stocker store_admin site_admin }

  attr_accessible :name, :store, :user

  belongs_to :user
  belongs_to :store
  # validates_presence_of :name
  validates_uniqueness_of :user_id, :scope => [ :store_id, :name ]

  def user_name
    user.name
  end

  def store_name
    store.name
  end

  def user_email
    user.email
  end

  def formatted_name
    self.name.gsub('_', ' ').capitalize if self.name
  end
end
