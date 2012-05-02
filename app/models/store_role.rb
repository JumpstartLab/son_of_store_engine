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
    user_for_role = User.find_by_email(input[:email])
    if user_for_role
      self.user = User.find_by_email(input[:email])
      self.permission = input[:role]
      self.save
      Resque.enqueue(NewStoreRoleEmailer, input[:email], self.store.id, role)
    else
      Resque.enqueue(NewUserAndStoreRoleEmailer, input[:email], self.store.id, role)
    end
  end

  def remove_role
    self.destroy
    Resque.enqueue(RemoveRoleEmailer, user.email, self.id)
  end
end
