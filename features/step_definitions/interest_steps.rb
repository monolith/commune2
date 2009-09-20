Given /^the following interest records?$/ do |table|

  # USAGE EXAMPLE ###############################
  # | interested  | interesting                |   #
  # | bob         | idea "Bobs great idea"  |   # 
  # | monolith    | idea "Bobs great idea"  |   #
  ###############################################
  
  Interest.destroy_all
    
  table.hashes.each do |attributes|
    interested = User.find_by_login(attributes[:interested])
    
    tmp = attributes[:interesting].split
    class_name = tmp.shift.capitalize
    interest = { :watch_type => class_name, :title => tmp.join(" ").gsub("\"","") }

    interesting = eval(class_name).find_by_title interest[:title]     
             
    interest = Interest.new
    interest.user = interested
    interest.interest = interesting

    interest.created_at = attributes[:created_at].to_time if attributes[:created_at]
    interest.save(false)
    
  end

  
end
