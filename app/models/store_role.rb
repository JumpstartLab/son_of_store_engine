class StoreRole < ActiveRecord::Base
  attr_accessible :store_id, :user_id
  belongs_to :store
  belongs_to :user

  def admin?
    permission == 9
  end
  
  def stocker?
    permission == 5
  end

  def role
    if permission == 9
      "ADMIN"
    else
      "STOCKER"
    end
  end

  def email
    
  end

  def new_user(input)
    u = User.find_by_email(input[:email])
    if u
      self.user = User.find_by_email(input[:email])
      self.permission = input[:role]
      self.save
      Notification.new_store_role(input[:email], self.store, role).deliver
    else
      Notification.new_user_and_store_role(input[:email], self.store, role).deliver
    end
  end

  def remove_role
    self.destroy
    Notification.remove_role(user.email, self.store).deliver
  end
end
