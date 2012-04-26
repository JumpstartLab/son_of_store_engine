class StoreRole < ActiveRecord::Base
  attr_accessible :store_id, :user_id
  belongs_to :store
  belongs_to :user

  def admin
    permission == 9
  end
  
  def stocker
    permission == 5
  end

end
