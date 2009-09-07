# custom steps based on webrat_steps.rb

Then /^I should see "([^\"]*)" button$/ do |name|
  button = find_button_with_value(name)
  button.should contain(name)

end

Then /^I should not see "([^\"]*)" button$/ do |name|
  button = find_button_with_value(name)
  button.should_not contain(name)
end

def find_button_with_value(name)

  doc = Hpricot(response.body)
  buttons = Hpricot(doc.search("[@type='submit']").to_html) # will find <input ... type=submit ....>
  button = buttons.search("[@value=#{name}]")
  # ugly code to get should to work below
  button.empty? ? "" : name
  
end


When /^I click on "([^\"]*)"$/ do |link|
  click_link(link)
end



