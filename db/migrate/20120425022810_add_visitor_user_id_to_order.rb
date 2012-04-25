class AddVisitorUserIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :visitor_user_id, :integer
  end
end
