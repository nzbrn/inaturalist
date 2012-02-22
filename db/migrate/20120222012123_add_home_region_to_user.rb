class AddHomeRegionToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :home_region, :string
  end

  def self.down
    remove_column :users, :home_region
  end
end
