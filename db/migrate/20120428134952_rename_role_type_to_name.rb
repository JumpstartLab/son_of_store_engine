class RenameRoleTypeToName < ActiveRecord::Migration
  def up
    rename_column :roles, :type, :name
  end

  def down
    rename_column :roles, :name, :type
  end
end
