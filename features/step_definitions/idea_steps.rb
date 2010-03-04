Given /^the following idea records?$/ do |table|
  Idea.destroy_all
  table.hashes.each do |attributes|
    author = { :login => attributes[:author] }
    idea = attributes.dup
    idea.delete("author")

    create_idea_with_industries!( { :idea => idea, :author => author } )
  end
end

Given /^the following suggestion records$/ do |table|
  # table is a Cucumber::Ast::Table

  Idea.destroy_all
  table.hashes.each do |attributes|
    author = { :login => attributes[:author] }
    idea = attributes.dup
    idea.delete("author")

    i = create_idea_with_industries!( { :idea => idea, :author => author } )

    industry = Industry.find_by_name "Commune2 Enhancement"
    i.industries.shift
    i.industries << industry
    i.save(false)
  end

end

