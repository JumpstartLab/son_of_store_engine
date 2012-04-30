class GuestUsersDrop < ActiveRecord::Migration
  def change
    drop_table :guest_users
  end
end
