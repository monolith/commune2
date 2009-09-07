Factory.define :user do |u|
  u.sequence(:login) { |n| "foo#{n}" }
  u.password "foobar"
  u.password_confirmation { |u| u.password }
  u.sequence(:email) { |n| "foo#{n}@example.com" }
  u.invited_by_id 0
  
#  u.association(:location, :factory => :location, :located_id => u.id )
  u.locations {|locations| [locations.association(:location, :located => u)]} 


end


Factory.define :location do |l|
  l.location "New York, NY, USA"
  l.country_name "USA"
  l.administrative_area_name "NY"
  l.locality_name "New York"
  l.latitude -73.986951
  l.longitude 42.102609

 end

