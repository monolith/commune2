Given /^the following watchlist records?$/ do |table|

  # USAGE EXAMPLE ###############################
  # | watcher     | watching                |   #
  # | bob         | idea "Bobs great idea"  |   # 
  # | monolith    | idea "Bobs great idea"  |   #
  ###############################################
  
  Watchlist.destroy_all
    
  table.hashes.each do |attributes|
    watcher = User.find_by_login(attributes[:watcher])
    
    tmp = attributes[:watching].split
    class_name = tmp.shift.capitalize
    watch = { :watch_type => class_name, :title => tmp.join(" ").gsub("\"","") }

    watching = case class_name
    
      when "User"
        User.find_by_login watch[:title]
      
      else
        eval(class_name).find_by_title watch[:title]     
             
    end

    watchlist = Watchlist.new
    watchlist.user = watcher
    watchlist.watch = watching

    watchlist.created_at = attributes[:created_at].to_time if attributes[:created_at]
    watchlist.save(false)
    
  end

  
end
