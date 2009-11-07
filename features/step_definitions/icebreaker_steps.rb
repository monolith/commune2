# /features/step_definitions/icebreaker_steps.rb

Given /^the following icebreaker records$/ do |table|
  # table is a Cucumber::Ast::Table

  Icebreaker.destroy_all
  table.hashes.each do |attributes|
      author = { :login => attributes[:author] }
      icebreaker = attributes.dup
      icebreaker.delete("author")
    
      create_icebreaker_with_author!( { :icebreaker => icebreaker, :author => author } )
  end

end



Given /^there are no icebreakers$/ do
  Icebreaker.destroy_all
end

When /^I try to create a new icebreaker$/ do
  begin
    current_user.icebreakers.make
  rescue
    # do nothing... this is a "try"
  end
end

Then /^there should be (.+) of icebreakers$/ do |number|
  Icebreaker.count.should == number.to_i
end

