
Given /^a new (.*)$/ do |class_name|
  # see blueprints.rb in support folder for details of how create_on_the_fly works
  @object = create_on_the_fly(class_name)
end


Given /^(.*) "([^\"]*)" becomes (.*)$/ do |class_name, attribute_value, state|
  object = case class_name.capitalize!
  when "User"
    User.find_by_login attribute_value
  else
    eval(class_name).find_by_title attribute_value    
  end
  
  state == "active" ? object.active = true : object.active = false
  object.save(false)
end

