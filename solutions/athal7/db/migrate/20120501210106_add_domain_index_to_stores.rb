class AddDomainIndexToStores < ActiveRecord::Migration
  def change
    add_index :stores, :domain
  end
end
