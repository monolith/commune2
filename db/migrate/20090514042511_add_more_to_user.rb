class AddMoreToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :no_cash_ok, :boolean, :default => true, :null => false
    add_column :users, :currently_available, :boolean, :default => true, :null => false
    add_column :users, :user_represents_entity, :boolean, :default => false, :null => false

    # also remove location previously added to users
    remove_column :users, :location
    remove_column :users, :country_name
    remove_column :users, :administrative_area_name
    remove_column :users, :locality_name
    remove_column :users, :latitude
    remove_column :users, :longitude

  end

  def self.down
    remove_column :users, :no_cash_ok
    remove_column :users, :currently_available
    remove_column :users, :representing_entity
      
    add_column :users, :location, :string, :limit => 90, :null => false
    add_column :users, :country_name, :string, :limit => 30, :null => true
    add_column :users, :administrative_area_name, :string, :limit => 30, :null => true
    add_column :users, :locality_name, :string, :limit => 30, :null => true
    add_column :users, :latitude, :float, :limit => 30, :null => true
    add_column :users, :longitude, :float, :limit => 30, :null => true

  end
end
