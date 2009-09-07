class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|

    t.references :located, :polymorphic => true, :null => false
    t.column :location, :string, :limit => 90, :null => false
    t.column :country_name, :string, :limit => 30, :null => true
    t.column :administrative_area_name, :string, :limit => 30, :null => true
    t.column :locality_name, :string, :limit => 30, :null => true
    t.column :latitude, :float, :limit => 30, :null => true
    t.column :longitude, :float, :limit => 30, :null => true

    t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
