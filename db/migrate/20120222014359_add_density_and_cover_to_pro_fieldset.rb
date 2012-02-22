class AddDensityAndCoverToProFieldset < ActiveRecord::Migration
  def self.up
    add_column :pro_fieldsets, :density, :float
    add_column :pro_fieldsets, :cover, :float
  end

  def self.down
    remove_column :pro_fieldsets, :cover
    remove_column :pro_fieldsets, :density
  end
end
