class AddVisitorUserToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :visitor_user, :reference
  end
end
