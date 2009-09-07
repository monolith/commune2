Given /^the following rating records?$/ do |table|

  Rating.destroy_all
  
  table.hashes.each do |attributes|
    rating = attributes.dup
    
    if attributes[:ratee] 
      ratee = { :login => attributes[:ratee] } 
      rating.delete("ratee")
    end    
  
    tmp = attributes[:rated].split
    class_name = tmp.shift.capitalize # e.g. will turn "idea" into "ideas"
    rated = { :class_name => class_name, :search_query => tmp.join(" ").gsub("\"", "") }
    rating.delete("rated")

    create_rating!( { :rating => rating, :ratee => ratee, :rated => rated } )

  end

end



Then /^average rating for (.*) "([^\"]*)" should be ([\d])$/ do |class_name, search_query, average|
  object = case class_name.capitalize!
    when "User"
      User.find_by_login search_query
    else
      eval(class_name).find_by_title search_query
  end

  object.scorecard.average.should == average.to_f  
end

