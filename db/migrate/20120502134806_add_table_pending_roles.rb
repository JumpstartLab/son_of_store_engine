class AddTablePendingRoles < ActiveRecord::Migration
  def change
    create_table "pending_roles", :force => true do |t|
      t.string   "email", :null => false
      t.integer  "role_id", :null => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
