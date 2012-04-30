class UserAddRoleColumn < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, :default => nil
    remove_column :users, :site_admin
  end
end
