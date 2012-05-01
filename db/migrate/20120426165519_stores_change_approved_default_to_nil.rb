class StoresChangeApprovedDefaultToNil < ActiveRecord::Migration
  def change
    change_column_default :stores, :approved, nil
  end
end
