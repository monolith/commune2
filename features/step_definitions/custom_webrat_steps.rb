# custom steps based on webrat_steps.rb


Then /^the "([^\"]*)" checkbox should not be checked$/ do |label|
  field_labeled(label).should_not be_checked
end

Then /^I should see "([^\"]*)" button$/ do |name|
  button = find_button_with_value(name)
  button.should contain(name)

end

Then /^I should not see "([^\"]*)" button$/ do |name|
  button = find_button_with_value(name)
  button.should_not contain(name)
end


When /^I click on "([^\"]*)"$/ do |link|
  click_link(link)
end


Then /^I should see "([^\"]*)" within "([^\"]*)"$/ do |text, div|
  selector = get_selector(div)
  selector.should contain(text)
end

Then /^I should not see "([^\"]*)" within "([^\"]*)"$/ do |text, div|
  selector = get_selector(div)
  selector.should_not contain(text)
end


Then /^I should see "([^\"]*)" image$/ do |alt|
  response.should have_selector('img', :alt => alt)
end

Then /^I should not see "([^\"]*)" image$/ do |alt|
  response.should_not have_selector('img', :alt => alt)
end


Then /^I should see a link to "([^\"]*)"$/ do |text|
  response_body.should have_selector("a") do |element|
    element.should contain(text)
  end

end


Then /^the output should include "([^\"]*)"$/ do |text|
  response.body.include?(text).should equal(true)
end

Then /^the output should not include "([^\"]*)"$/ do |text|
  response.body.include?(text).should_not equal(true)
end

Then /^I should have (\d+) emails?$/ do |n|
  mailbox_for(current_email_address).size.should == n.to_i
end

private

# functions used by the above

def get_selector(name)
  doc = Hpricot(response.body)
  Hpricot(doc.search("[@id='#{name}']").to_html)
end

def find_button_with_value(name)
  doc = Hpricot(response.body)
  buttons = Hpricot(doc.search("[@type='submit']").to_html) # will find <input ... type=submit ....>
  button = buttons.search("[@value=#{name}]")
  # ugly code to get should to work below
  button.empty? ? "" : name
end

