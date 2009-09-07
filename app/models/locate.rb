class Locate < Array
  require 'open-uri'
  require 'hpricot'

  attr_reader :status, :message, :count
  
  def initialize(address)
   # initialize method requires an address string

   @count = 0
   @status = 0
   
   if address.class != String || address.strip.length == 0
      @message = "No address/location provided (blank was submitted)"
       return
   end
      
   if address.include? "Coordinates" # if only coordinates found... likely some remote place
      @status = 200
      @count = 1
      message = "Using coordinates"
      point = address.split(" ")[1].split(",")
      self << {:location => address,
               :latitude => point[0].to_f,
               :longitude => point[1].to_f
               }
      return
   end
      
    # GoogleAPIKey needs to be set as a constant in environment.rb
    found = Hpricot.XML(open("http://maps.google.com/maps/geo?#{ address.to_query 'q' }&output=xml&oe=utf8&sensor=false&key=" + GoogleAPIKey ))

    @status = found.get_elements_by_tag_name('code').innerHTML.to_i
    @message = set_message(@status)
  
    if found
      found.get_elements_by_tag_name('Placemark').each do |place|
      point = place.get_elements_by_tag_name('coordinates').innerHTML.split ','

      # country is minimum
      location = place.get_elements_by_tag_name('LocalityName').innerHTML # city
      location << ", " if location.length > 0
      location << place.get_elements_by_tag_name('AdministrativeAreaName').innerHTML # state
      location << ", " if location.length > 0      
      location << place.get_elements_by_tag_name('CountryName').innerHTML # country
      
      location = "Coordinates: " << place.get_elements_by_tag_name('coordinates').innerHTML if location.blank? # coordinates only if no other info found

      self << { :country_name => place.get_elements_by_tag_name('CountryName').innerHTML,
                :administrative_area_name => place.get_elements_by_tag_name('AdministrativeAreaName').innerHTML,
                :locality_name => place.get_elements_by_tag_name('LocalityName').innerHTML,
                :latitude => point[0].to_f,
                :longitude => point[1].to_f,
                :location => location
                 }
      end
      
    end

    @count = self.size

    unless @status == 200 # worst case scenario, lets user save location that they manually entered
      if @status == 500 || @status == 610 || @status == 620 || @message == "Unknown code."
        self << {:location => address.to_s}
      end
    end    
             
  end
    
  def set_message(code)
    case code

      when 200
        "No errors occurred; the address was successfully parsed and its geocode has been returned."

      when 400
        "A directions request could not be successfully parsed. For example, the request may have been rejected if it contained more than the maximum number of waypoints allowed."

      when 500
        "A geocoding or directions request could not be successfully processed, yet the exact reason for the failure is not known."

      when 601
        "The HTTP q parameter was either missing or had no value. For geocoding requests, this means that an empty address was specified as input. For directions requests, this means that no query was specified in the input."
   
      when 602
        "No corresponding geographic location could be found for the specified address (location). Try entering your city or country"
        
      when 603
        "The geocode for the given address or the route for the given directions query cannot be returned due to legal or contractual reasons."   
      
      when 604
        "The GDirections object could not compute directions between the points mentioned in the query. This is usually because there is no route available between the two points, or because we do not have data for routing in that region."

      when 610
        "The given key is either invalid or does not match the domain for which it was given."

      when 620
        "The given key has gone over the requests limit in the 24 hour period or has submitted too many requests in too short a period of time."

      else
        "Unknown code."
      end

  end




  def add(object)
  
    if self.count == 1
      # find geocode for location (ensure actual address is not saved)
        city_location = Locate.new self.first[:location]
        object_location = Location.new( :location => self.first[:location],
                                      :country_name => self.first[:country_name],
                                      :administrative_area_name => self.first[:administrative_area_name],
                                      :locality_name => self.first[:locality_name],
                                      :latitude => city_location.first[:latitude],
                                      :longitude => city_location.first[:longitude] )

          if object.locations.find_by_location(object_location.location).blank?
            object.locations << object_location
            return { :status => true, :message => "Location added" }

          else
            return { :status => false, :message => "NOT SAVED! You are trying to add a location which you already have" }
          end
    elsif self.count > 1      
        return { :status => false, :message => "NOT SAVED! Please select location (multiple were found)" }
    else
        return { :status => false, :message => "NOT SAVED! " + self.message }
    end

  end


end
