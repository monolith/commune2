When /^I check one of the general skills$/ do
  skills = GeneralSkill.all
  id = rand(skills.size)
  
  check_box_id = "skill_ids_" + skills[id].id.to_s
  check(check_box_id)
end
