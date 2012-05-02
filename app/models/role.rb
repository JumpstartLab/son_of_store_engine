class Role < ActiveRecord::Base
  attr_accessible :name, :store, :user

  belongs_to :user
  belongs_to :store

  def user_name
    user.name
  end

  def store_name
    store.name
  end

  def notify_user_of_role_removal
    if name == "store_stocker"
      Resque.enqueue(RoleEmailer, "store_stocker_removal_notification", user.id)
    elsif name == "store_admin"
      Resque.enqueue(RoleEmailer, "store_admin_removal_notification", user.id)
    end 
  end

  def notify_user_of_role_addition
    if name == "store_admin"
      Resque.enqueue(RoleEmailer, "store_admin_addition_notification", user.id)
    elsif name == "store_stocker"
      Resque.enqueue(RoleEmailer, "store_stocker_addition_notification", user.id)
    end
  end
end