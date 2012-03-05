class RemoveHomeRegionFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :home_region
  end

  def self.down
    add_column :users, :home_region, :string
  end
end
