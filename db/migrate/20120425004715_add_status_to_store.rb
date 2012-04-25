class AddStatusToStore < ActiveRecord::Migration
  def change
    add_column :stores, :status, :string, default: "pending"
  end
end
