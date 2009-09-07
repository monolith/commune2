Given /^the following idea records?$/ do |table|
  Idea.destroy_all
  table.hashes.each do |attributes|
    author = { :login => attributes[:author] }
    idea = attributes.dup
    idea.delete("author")
    
    create_idea_with_industries!( { :idea => idea, :author => author } )
  end
end

