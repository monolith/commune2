
When /^I check one of the industries$/ do
  industries = Industry.all
  id = rand(industries.size)
  
  check_box_id = "industry_ids_" + industries[id].id.to_s
  check(check_box_id)
end

