class AddActiveToPromo < ActiveRecord::Migration
  def self.up
    add_column :promos, :active, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :promos, :active
  end
 end

