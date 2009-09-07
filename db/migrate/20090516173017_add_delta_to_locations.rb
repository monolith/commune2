class AddDeltaToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :delta, :text
  end

  def self.down
    remove_column :locations, :delta
  end
end
