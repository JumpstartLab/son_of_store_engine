class StoreAdmin < ActiveRecord::Base
  attr_accessible :user_id, :store_id

  belongs_to :user
  belongs_to :store
  after_create :new_admin_notification_email
  after_destroy :admin_removal_email

  def new_admin_notification_email
    Resque.enqueue(Emailer, "admin", "new_admin_notification", user.email, store.id)
  end

  def self.request_signup(email)
    Resque.enqueue(Emailer, "admin", "request_signup", email, store.id)
  end

  def admin_removal_email
    Resque.enqueue(Emailer, "admin", "admin_removal", user.id, store.id)
  end

end