Given /^the following promo records?$/ do |table|
  Promo.destroy_all
  table.hashes.each do |attributes|
    Promo.make(attributes)
  end
end


Then /^"([^\"]*)" promo should have ([\d]) users?$/ do |code, count|
  Promo.find_by_code(code).users.count.should == count.to_i
end

