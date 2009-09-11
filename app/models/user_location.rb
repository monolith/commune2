class UserLocation < ActiveRecord::Base
 # this is really used for purposes of indexing and searching, otherwise model not needed
 # done this way due to limitation on sphinx to do geosearch based on many locations of one user
 # really an issue of how it works with floats

  belongs_to :user
  belongs_to :location
  
  attr_accessible # nothing
    
  define_index do
    indexes [user.first_name, user.last_name, user.company, user.login], :as => :person
    indexes user.headline, :as => :headline    
    indexes user.purpose, :as => :purpose    
    indexes user.education, :as => :education
    indexes user.skills, :as => :skills
    indexes user.general_skills.name, :as => :general_skill 
    indexes user.industries.name, :as => :industry
    indexes [user.projects.title, user.projects.description], :as => :project
    indexes [user.ideas.title, user.ideas.description], :as => :idea
    indexes [user.jobs.title, user.jobs.description], :as => :job
    indexes user.scorecard.scorable_type
    indexes location.location, :as => :location
    indexes location.located_type
    has user.created_at
    has user.scorecard.adjusted_rating, :as => :adjusted_rating

    # geocode search
    has 'RADIANS(locations.latitude)', :as => :latitude,  :type => :float
    has 'RADIANS(locations.longitude)', :as => :longitude,  :type => :float
    has user_id  

    set_property :latitude_attr   => "latitude"
    set_property :longitude_attr  => "longitude"
    set_property :delta => true 

    where "users.active = true and users.activated_at > 0" # search only activated users

    # EXAMPLE
    # results=UserLocation.search :geo => [-73.986951 * Math::PI / 180, 40.756054 * Math::PI / 180], :group_by => 'user_id', :group_function => :attr, :order => "@geodist asc" 

  # results.each_with_geodist do |result, distance|
  # puts result.user.login + " is " + (distance / 1609.344).to_i.to_s + " miles away from New York, NY"
  # end 


  end


end
