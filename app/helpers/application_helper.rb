

# Methods added to this helper will be available to all templates in the application.


module ApplicationHelper

  def menu_link_class(section, item)
    # this determine proper span or div id for top level menu (banner),
    # this helps highlight the section the user is currently on

    # action is needed because of things like watchlist/ideas
    request.path_parameters[:controller] == section || request.path_parameters[:action] == section ? "menu-#{item}-highlight" : "menu-#{item}"
  end

  def menu_filler_class(section)
    # this determine proper span or div id for top level menu (banner),
    # this helps highlight the section the user is currently on

    # action is needed because of things like watchlist/ideas
    request.path_parameters[:controller] == section || request.path_parameters[:action] == section ? "menu-filler-highlight" : "menu-filler"
  end

  def section_icon
    img_path = ""
    case request.path_parameters[:controller]
      when "ideas"
        img_path << "ideas_icon_lg.png"
      when "projects"
        img_path << "projects_icon_lg.png"
      when "jobs"
        img_path << "jobs_icon_lg.png"
      when "users", "invitations", "profiles"
        img_path << "people_icon_lg.png"
    else # watchlist / interests / etc
      case request.path_parameters[:action]
        when "ideas"
          img_path << "ideas_icon_lg.png"
        when "projects"
          img_path << "projects_icon_lg.png"
        when "jobs"
          img_path << "jobs_icon_lg.png"
        when "users", "profiles"
          img_path << "people_icon_lg.png"        
      end
    end
    
    if img_path.length > 0
      image_tag("menu_icons/" + img_path, :border=> 0)
    else
      "&nbsp;"
    end
  end

  def div_tag_for(object)
    # depends on current_user as the logged in user variable
    # checks derives the right div for object
    # for example checks if object is on whatchlist
    unless current_user
      id = "not_logged_in"
    else
    
      id =  case object.class.to_s

      when "Idea", "Project", "User"
        if object.active == false
          "snippet-inactive"
        elsif current_user.watched_ideas.include?(object)  
          "snippet-watching"
        else
          "snippet"
        end
      
      when "Job"
        if object.active == false
          "snippet-inactive"
        elsif current_user.watched_ideas.include?(object)  
          "snippet-watching"
        elsif object.status.upcase == "FILLED"
          "job-filled"  
        else
          "snippet"
        end        
      else
        "not_mapped"      
      end

    end
    
    tag("div", :id => id)

  end
  
  
  def dashboard_for(object)
    return unless current_user # no dashboard unless logged in
    dashboard = ""
    
    @icons_show = false

    case object.class.to_s
      
      when "Idea"
        if current_user.watched_ideas.include?(object)
          watching = true

          count = recent_comments_count(object)
          (dashboard << " | " << show_comments_count(count)) if count > 0

          count = recent_watchers_count(object)
          (dashboard << " | " << show_watchers_count(count)) if count > 0

          count = recent_interested_count(object)
          (dashboard << " | " << show_interested_count(count)) if count > 0
          
          count = recent_projects_count(object)
          (dashboard << " | " << show_projects_count(count)) if count > 0

          unless dashboard.blank?
            dashboard = dashboard[3..dashboard.size] # removes the first " | "
            dashboard = "<b style='color:#F4C430'>NEW:</b> " << dashboard
          end

        end

      when "Project"
        if current_user.watched_projects.include?(object)
          watching = true
          
          count = recent_comments_count(object)
          (dashboard << " | " << show_comments_count(count)) if count > 0

          count = recent_watchers_count(object)
          (dashboard << " | " << show_watchers_count(count)) if count > 0

          count = recent_interested_count(object)
          (dashboard << " | " << show_interested_count(count)) if count > 0
          
          count = recent_jobs_count(object)
          (dashboard << " | " << show_jobs_count(count)) if count > 0
          
          count = recent_members_count(object)
          (dashboard << " | " << show_members_count(count)) if count > 0

          unless dashboard.blank?
            dashboard = dashboard[3..dashboard.size] # removes the first " | "
            dashboard = "<b style='color:#F4C430'>NEW:</b> " << dashboard
          end

        end


      when "Job"
        if current_user.watched_jobs.include?(object)

          watching = true
          dashboard = tag("strong") << "Status: " << tag("/strong")

          if object.open
            dashboard << "Open"
          else
            hired = object.hired_user
            if hired == current_user        
              dashboard << "You are hired!"
            else
              dashboard << "Hired " << h(hired.login) 
            end
          end

        end      

      when "User"
        if current_user.watched_people.include?(object)
          watching = true

          count = recent_comments_count(object)
          (dashboard << " | " << show_comments_count(count)) if count > 0

          count = recent_ideas_count(object)
          (dashboard << " | " << show_ideas_count(count)) if count > 0

          count = recent_projects_count(object)
          (dashboard << " | " << show_projects_count(count)) if count > 0

          count = recent_jobs_count(object)
          (dashboard << " | " << show_jobs_count(count)) if count > 0


          unless dashboard.blank?
            dashboard = dashboard[3..dashboard.size] # removes the first " | "
            dashboard = "<b style='color:#F4C430'>NEW:</b> " << dashboard
          end

        end


    end
   
    if watching

      
      if object.updated_since? current_user.logon.previous
        dashboard = tag("strong") << "Updated: " << tag("/strong") << 
                      time_ago_in_words(object.updated_at) << " ago" <<
                      tag("br") << dashboard
      end
      
      dashboard = "No change since your last logon" if dashboard.blank?
      # return
      tag("div", :id => "dashboard") << dashboard << tag("/div")

    end
  
  end
  
  
  def stats_for(object, options={})

    @icons_show = options[:icons_show] || true
    @icons_side = options[:icons_side] || "right"
    breakout = options[:breakout] || false

    stats = object.active ? "" : "<b style='color:#CF4326'>INACTIVE</b><hr />"
    
    case object.class.to_s
      
      when "Idea"

          stats << show_comments_count(total_comments(object)) << tag("br")
          stats << show_watchers_count(total_watchers(object)) << tag("br")
          stats << show_interested_count(total_interested(object)) << tag("br")

          if breakout
            object.interested.each do |profile|
              stats << "&nbsp;&nbsp;&nbsp;&nbsp;" << link_to(h(profile.login), user_path(profile)) << tag("br")
            end       
          end

          stats << show_projects_count(active_projects(object))

          if breakout
            object.active_projects.each do |project|
              stats << "&nbsp;&nbsp;&nbsp;&nbsp;" << link_to(h(project.title), project_path(project)) << tag("br")
            end
          end
      
      when "Project"

          stats << show_members_count(active_members(object)) << tag("br")
          stats << show_comments_count(total_comments(object)) << tag("br")
          stats << show_watchers_count(total_watchers(object)) << tag("br")

          stats << show_interested_count(total_interested(object)) << tag("br")
          if breakout
            object.interested.each do |profile|
              stats << "&nbsp;&nbsp;&nbsp;&nbsp;" << link_to(h(profile.login), user_path(profile)) << tag("br")
            end       
          end

          stats << show_jobs_count(active_jobs(object)) << tag("br")
          if breakout
            object.open_jobs.each do |job|
              stats << "&nbsp;&nbsp;&nbsp;&nbsp;" << link_to(h(job.title), job_path(job)) << tag("br")
            end       
          end

      when "User"

          stats << show_comments_count(total_comments(object)) << tag("br")
          stats << show_ideas_count(active_ideas(object)) << tag("br")
          stats << show_projects_count(active_projects(object)) << tag("br")
          stats << show_jobs_count(active_jobs(object))  << tag("br")
          stats << show_watchers_count(total_watchers(object))
      

      when "Job"
          if object.status.upcase == "OPEN"
            stats << "<b>" << object.status.upcase << "</b>"  << tag("br")
          elsif object.status.upcase == "FILLED"
            stats << "<b>" << object.status.downcase << "</b>"  << tag("br")
          else
            stats << object.status.downcase << tag("br")          
          end

          stats << show_watchers_count(total_watchers(object)) << tag("br")
          stats << show_applicants_count(object.applicants.count) << tag("br")

    end
    
    stats
  end
  
  
  # TOTAL
  def total_comments(object)
    object.scorecard.total_comments_count
  end
  
  def total_watchers(object)
    object.watchers_count
  end
  
  def total_interested(object)
    object.interested_count    
  end


  #ACTIVE

  def active_ideas(object)
    object.scorecard.active_ideas_count
  end  

  def active_projects(object)
    object.scorecard.active_projects_count
  end  
  
  def active_jobs(object)
    object.scorecard.active_jobs_count
  end  
 
  def active_members(object)
    object.scorecard.active_members_count
  end  

  # RECENT (since previous logon)
  # user should be logged in as current_user
  # initial check here performed in dashboard method, so not checked here
  
  def recent_comments_count(object) 
    object.comments_since current_user.logon.previous
  end
  
  def recent_watchers_count(object)
    object.watchers_since current_user.logon.previous
  end
  
  def recent_interested_count(object)
    object.interested_since current_user.logon.previous
  end
  
  def recent_projects_count(object)
    object.projects_since current_user.logon.previous
  end

  def recent_members_count(object)
    object.members_since current_user.logon.previous
  end

  def recent_jobs_count(object)
    object.jobs_since current_user.logon.previous
  end

  def recent_ideas_count(object)
    object.ideas_since current_user.logon.previous
  end
  
  # END RECENT
  
    
  # START DISPLAY (show)
  def table_this(left, right)
   width_left=''
   width_right=''
    if @icons_side == "left"
      tmp = left
      left = right
      right = tmp
      width_left="width='30'"
      
    else
      width_right="width='30'"
    
    end

      "<table border='0' cellspacing='0' cellpadding='0' align='right' width='100%'><tr><td valign='center' align='#{@icons_side}' #{ width_left}>" << left << "</td><td valign='center' align='#{@icons_side}' #{ width_right}>" << right << "</td></tr></table>"

  end
  
  def show_comments_count(count)
    if @icons_show
      table_this(pluralize(count, "comment"), image_tag("other_icons/comment_icon_sm.png", :border => 0))
    else
      pluralize(count, "comment")
    end
  end

  def show_watchers_count(count)
    if @icons_show
      table_this(count.to_s + " watching", image_tag("other_icons/watching_icon_sm.png", :border => 0))
    else
      count.to_s + " watching"
    end
  end

  def show_interested_count(count)
    if @icons_show
      table_this(count.to_s + " interested", image_tag("other_icons/interest_icon_sm.png", :border => 0))
    else      
      count.to_s + " interested"
    end
  end

  def show_projects_count(count)
    if @icons_show
      table_this(pluralize(count, "project"), image_tag("other_icons/projects_icon_sm.png", :border => 0))
    else
      pluralize(count, "project")
    end
  end
  
  def show_members_count(count)
    if @icons_show
      table_this(pluralize(count, "member"), image_tag("other_icons/member_icon_sm.png", :border => 0))
    else
      pluralize(count, "member")
    end
  end

  def show_jobs_count(count)
    if @icons_show
      table_this(pluralize(count, "job"), image_tag("other_icons/jobs_icon_sm.png", :border => 0))
    else
      pluralize(count, "job")
    end
  end

  def show_ideas_count(count)
    if @icons_show
     table_this(pluralize(count, "idea"), image_tag("other_icons/ideas_icon_sm.png", :border => 0))
    else
      pluralize(count, "idea")
    end
  end
  
  def show_applicants_count(count)
    if @icons_show
      table_this(pluralize(count, "applicants"), image_tag("other_icons/applicants_icon_sm.png", :border => 0))
    else
      pluralize(count, "applicants")
    end
  end
  
  
  
  def show_description(object)
    if object.active
      description  = h(object.description[0..150])
      if object.description.length > 150
        description << "..."
      end
      description # return
    else
      "<i>Inactive " << object.class.to_s.downcase << "...</i>"
    end
    
  end
  
  
  
  def button_to_delete_if_allowed(object)
    if current_user.admin?

#      button = button_to "Delete " << object.class.to_s,
#               polymorphic_path(object),
#               :id => "delete",
#               :method => :delete,
#               :confirm => "Cannot undo! Delete this " <<
#                  object.class.to_s.downcase + "?"

#      "<hr>" << button
      
      
      
      link_to("delete " + object.class.to_s.downcase,
                polymorphic_path(object),
                :id => "delete",
                :method => :delete,
                :confirm => "Cannot undo! Delete this " << object.class.to_s.downcase + "?",
                :class => "action_menu_delete"
              )
    end
  end
  
  
  def show_recent_ideas_and_projects
    items = Scorecard.recent(3)
    
    html =[]
    items.each do |thing| 
      html << "<h3>" + link_to(h(thing.title), thing) + "</h3>"     
      html << h(thing.description[0..150])
      html << "..." if thing.description.size > 150

    end
    
    html
  end


  def display_dashboard

    unless current_user
      "Dashboard not available."
    else

      counts = current_user.dashboard_stats

      mystuff = counts[:mystuff]
      
      
      mycount = mystuff[:totals][:recent_comments] + mystuff[:totals][:recent_watching] +
                mystuff[:totals][:recent_interested] + mystuff[:totals][:recent_projects] + mystuff[:totals][:recent_applications]


      my_html =""
      if mycount > 0

        my_html = "<div id='dashboard-my'>"        
        my_html << "<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'><tr><td width='30' valign='center' align='center' bgcolor='#A0C943'>"
        my_html << image_tag("submenu_icons/my_submenu_icon.png", :border=> 0, :title => "My Stuff") + "</td><td valign='center' align='left'>&nbsp;" 
        my_html << " Comments: <b>" + mystuff[:totals][:recent_comments].to_s + "</b> |" if mystuff[:totals][:recent_comments] > 0
        my_html << " Watchers: <b>" + mystuff[:totals][:recent_watching].to_s + "</b> |" if mystuff[:totals][:recent_watching] > 0
        my_html << " Interested: <b>" + mystuff[:totals][:recent_interested].to_s + "</b> |" if mystuff[:totals][:recent_interested] > 0
        my_html << " Projects (from my ideas): <b>" + mystuff[:totals][:recent_projects].to_s + "</b> |" if mystuff[:totals][:recent_projects] > 0
        my_html << " Job Applications: <b>" + mystuff[:totals][:recent_applications].to_s + "</b> |" if mystuff[:totals][:recent_applications] > 0
        my_html << "</td></tr></table></div>"
      end
      
      
      watching = counts[:watching]
   
      
      watch_html =""
      if watching[:totals][:recent_ideas] + watching[:totals][:recent_projects] + watching[:totals][:recent_jobs]> 0

        watch_html = "<div id='dashboard-watchlist'>"
        watch_html << "<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'><tr><td width='30' valign='center' align='center' bgcolor='#A0C943'>"
        watch_html << image_tag("submenu_icons/watchlist_submenu_icon.png", :border=> 0, :title => "Watchlist") + "</td><td valign='center' align='left'>&nbsp;" 
              
        watch_html << " Ideas: <b>" + watching[:totals][:recent_ideas].to_s + "</b> |" if watching[:totals][:recent_ideas] > 0
        watch_html << " Projects: <b>" + watching[:totals][:recent_projects].to_s + "</b> |" if watching[:totals][:recent_projects] > 0
        watch_html << " Jobs: <b>" + watching[:totals][:recent_jobs].to_s + "</b> |" if watching[:totals][:recent_jobs] > 0

        watch_html << "</td></tr></table></div>"
      end
         
      if my_html.length + watch_html.length > 0
        "<div id=\"dashboard-container\">" + my_html + watch_html + "</div>"
      end
      
      
    end
  end    
  
  
end
