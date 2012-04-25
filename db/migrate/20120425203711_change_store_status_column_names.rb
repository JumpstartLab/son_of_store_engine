class ChangeStoreStatusColumnNames < ActiveRecord::Migration
  def change
    rename_column :stores, :status, :approval_status
  end
end
