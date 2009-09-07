class AddLocationToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :location, :string, :limit => 90, :null => false
    add_column :users, :country_name, :string, :limit => 30, :null => true
    add_column :users, :administrative_area_name, :string, :limit => 30, :null => true
    add_column :users, :locality_name, :string, :limit => 30, :null => true
    add_column :users, :latitude, :float, :limit => 30, :null => true
    add_column :users, :longitude, :float, :limit => 30, :null => true
  end

  def self.down
    remove_column :users, :location
    remove_column :users, :country_name
    remove_column :users, :administrative_area_name
    remove_column :users, :locality_name
    remove_column :users, :latitude
    remove_column :users, :longitude
  end
end
