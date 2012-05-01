class AddVisitorUserToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :visitor_user_id, :integer
  end
end
