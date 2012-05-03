class StoreAdmin < ActiveRecord::Base
  attr_accessible :user_id, :store_id, :stocker

  validates_uniqueness_of :user_id, :scope => :store_id

  belongs_to :user
  belongs_to :store
  after_create :new_admin_notification_email
  after_destroy :admin_removal_email

  def role
    if stocker
      "stocker"
    else
      "admin"
    end
  end

  def self.request_signup(email, store)
    Resque.enqueue(Emailer, "admin", "request_signup", email, store.id)
  end

  def new_admin_notification_email
    unless user == store.owner
      Resque.enqueue(Emailer, "admin", "new_admin_notification", user_id, store_id, role)
    end
  end

  def admin_removal_email
    Resque.enqueue(Emailer, "admin", "admin_removal", user_id, store_id, role)
  end
end
