Given /^the following project records?$/ do |table|
  Project.destroy_all
  table.hashes.each do |attributes|
    project = attributes.dup

    if attributes[:author] 
      author = { :login => attributes[:author] } 
      project.delete("author") if attributes[:author]
    end    
    
    if attributes[:idea]
      idea = { :title => attributes[:idea] }
      project.delete("idea")  if attributes[:idea]
    end
    
    create_project_with_industries!( { :project => project, :idea => idea, :author => author } )
  end
end


Then /^the "([^\"]*)" project should have ([\d]) members?$/ do |title, count|
  Project.find_by_title(title).should have(count.to_i).members
end

Then /^"([^\"]*)" should be a member of (.*)$/ do |login, title|
  user = User.find_by_login login
  Project.find_by_title(title).members.should include(user)
end

