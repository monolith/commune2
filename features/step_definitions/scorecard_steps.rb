
Given /^my scorecard has (.*) "([^\"]*)"$/ do |score, attribute|
  current_user.scorecard[attribute].should == score.to_i
end

Then /^my scorecard should have (.*) "([^\"]*)"$/ do |score, attribute|
  current_user.scorecard[attribute].should == score.to_i
end

Then /^the object should have a scorecard$/ do
  @object.should respond_to(:scorecard)  
  @object.scorecard.class.should equal(Scorecard)
end

Then /^the scorecard should be blank$/ do
  @object.scorecard.should be_blank
end


Then /^scorecard for (.*) "([^\"]*)" should have ([\d]) (.*)$/ do |class_name, search_string, count, attribute|
  # this DOES NOT work (not intended) for average, ratings count, or adjusted rating 
  # this COVERS ONLY total comments, active ideas, active projects, active jobs, and active members counts
 
  class_name.capitalize!

  scorecard = case class_name
    when "User"
      eval(class_name).find_by_login(search_string).scorecard
    when "Idea"
      eval(class_name).find_by_title(search_string).scorecard
    when "Project"
      eval(class_name).find_by_title(search_string).scorecard    
  end

  tmp = attribute.split
  tmp[1] = tmp.second.pluralize # e.g. will turn "idea" into "ideas"
  tmp.push "count"
  attribute = tmp.join("_")

  scorecard.attributes[attribute].should == count.to_i

end
