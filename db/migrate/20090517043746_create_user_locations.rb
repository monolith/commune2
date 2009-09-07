class CreateUserLocations < ActiveRecord::Migration
  def self.up
    create_table :user_locations do |t|
     t.column :user_id, :integer, :null => true
     t.column :location_id, :integer, :null => true
     t.column :delta, :text
     t.timestamps
    end
    
    a= User.find :all
    a.each do |usr|
      usr.locations.each do | loc |
        UserLocation.create :user_id => usr.id, :location_id => loc.id      
      end
    end
  end

  def self.down
    drop_table :user_locations
  end
end
