class Location < ActiveRecord::Base
  belongs_to :located, :polymorphic => true
  
  validates_presence_of     :location
  validates_uniqueness_of   :location, :scope => [:located_id, :located_type], :message => "Location already exists"
  
  after_save :update_location_for_indexing

  attr_accessible :location,
                  :country_name,
                  :administrative_area_name,
                  :locality_name,
                  :latitude,
                  :longitude

  
  define_index do
    indexes location
    indexes located_type    

    has located_id
    # geocode search
    has 'RADIANS(latitude)', :as => :latitude,  :type => :float
    has 'RADIANS(longitude)', :as => :longitude,  :type => :float

    set_property :latitude_attr   => "latitude"
    set_property :longitude_attr  => "longitude"
    set_property :delta => true
  end

  private
  
  def update_location_for_indexing
  
    case located_type 
        when "User"
          UserLocation.create :user_id => located_id, :location_id => id

        # need to add others here
      
   end   

    
  end

end

