

# Methods added to this helper will be available to all templates in the application.


module ApplicationHelper

  def div_tag_for(object)
    # depends on current_user as the logged in user variable
    # checks derives the right div for object
    # for example checks if object is on whatchlist
    unless current_user
      id = "not_logged_in"
    else
    
      id =  case object.class.to_s

              when "Idea"
                if object.active == false
                  "ideasnippet-inactive"
                elsif current_user.watching_ideas.include?(object)  
                  "watchlist_ideasnippet"
                else
                  "ideasnippet"
                end

              when "Project"
                if object.active == false
                  "projectsnippet-inactive"
                elsif current_user.watching_projects.include?(object)  
                  "watchlist_projectsnippet"
                else
                  "projectsnippet"
                end              

              when "Job"
                if object.active == false
                  "jobsnippet-inactive"
                elsif current_user.watching_jobs.include?(object)  
                  "watchlist_jobsnippet"
                else
                  "jobsnippet"
                end              

              when "User"
                if object.active == false
                  "profilesnippet-inactive"
                elsif current_user.watching_users.include?(object)  
                  "watchlist_profilesnippet"
                else
                  "profilesnippet"
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

    case object.class.to_s
      
      when "Idea"
        if current_user.watching_ideas.include?(object)
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
            dashboard = tag("strong") << "New:" << tag("/strong") << " " << dashboard
          end

        end

      when "Project"
        if current_user.watching_projects.include?(object)
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
            dashboard = tag("strong") << "New:" << tag("/strong") << " " << dashboard
          end

        end


      when "Job"
        if current_user.watching_jobs.include?(object)

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
        if current_user.watching_users.include?(object)
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
            dashboard = tag("strong") << "New:" << tag("/strong") << " " << dashboard
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
  
  
  def stats_for(object)
    stats = ""

    case object.class.to_s
      
      when "Idea"
          stats = "Posted " + time_ago_in_words(object.created_at) + " ago" + tag("br")

          stats << show_comments_count(total_comments(object)) << " | "
          stats << show_watchers_count(total_watchers(object)) << " | "
          stats << show_interested_count(total_interested(object)) + " | "
          stats << show_projects_count(active_projects(object))

      when "Project"
          stats = "Posted " + time_ago_in_words(object.created_at) + " ago" + tag("br")

          stats << show_comments_count(total_comments(object)) << " | "
          stats << show_watchers_count(total_watchers(object)) << " | "
          stats << show_interested_count(total_interested(object)) << " | "
          stats << show_jobs_count(active_jobs(object)) << " | "
          stats << show_members_count(active_members(object))

      when "User"
          stats << pluralize(total_watchers(object), "Watcher") << " | "

          stats << show_comments_count(total_comments(object)) << " | "
          stats << show_ideas_count(active_ideas(object)) << " | "
          stats << show_projects_count(active_projects(object)) << " | "
          stats << show_jobs_count(active_jobs(object))

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
  
  def show_comments_count(count)
    pluralize count, "Comment"
  end

  def show_watchers_count(count)
    count.to_s << " Watching"
  end

  def show_interested_count(count)
    count.to_s << " Interested"
  end

  def show_projects_count(count)
    pluralize count, "Project"
  end
  
  def show_members_count(count)
    pluralize count, "Member"
  end

  def show_jobs_count(count)
    pluralize count, "Job"
  end

  def show_ideas_count(count)
    pluralize count, "Idea"
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
      button = button_to "Delete " << object.class.to_s,
               polymorphic_path(object),
               :id => "delete",
               :method => :delete,
               :confirm => "Cannot undo! Delete this " <<
                  object.class.to_s.downcase + "?"

      "<p>" << button << "</p>"
    end
  end
  
  
  def show_recent_ideas_and_projects
    items = Scorecard.recent(3)
    
    html =[]
    items.each do |thing| 
      html << "<h3>" + link_to(h(thing.title), thing) + "</h3>"     
      html << h(thing.description[0..200])
      html << "..." if thing.description.size > 200

    end
    
    html
  end


  def dashboard
    unless current_user
      "Dashboard not available."
    else

      # count various idea stats    
      ideas_projects_count    = current_user.recent_projects_from_ideas_count
      ideas_interested_count  = current_user.recent_interests_in_ideas_count
      ideas_watchers_count    = current_user.recent_watchlists_for_ideas_count
      ideas_comments_count    = current_user.recent_comments_on_ideas_count

      ideas_text = ""
      if ((ideas_projects_count + ideas_interested_count + ideas_watchers_count + ideas_comments_count) > 0)
        ideas_text = " <b>IDEAS |</b>"
        ideas_text << " projects:" + ideas_projects_count.to_s if ideas_projects_count > 0
        ideas_text << " interested:" + ideas_interested_count.to_s if ideas_interested_count > 0
        ideas_text << " watchers:" + ideas_watchers_count.to_s if ideas_watchers_count > 0
        ideas_text << " comments:" + ideas_comments_count.to_s if ideas_comments_count > 0
      end

      # count various idea stats    
      projects_jobs_count       = current_user.recent_jobs_for_projects_count
      projects_interested_count = current_user.recent_interests_in_projects_count
      projects_watchers_count   = current_user.recent_watchlists_for_projects_count
      projects_comments_count   = current_user.recent_comments_on_projects_count

      projects_text = ""
      if ((projects_jobs_count + projects_interested_count + projects_watchers_count + projects_comments_count) > 0)
        projects_text = " <b>PROJECTS |</b>"
        projects_text << " interested: " + projects_interested_count.to_s if projects_interested_count > 0
        projects_text << " watchers: " + projects_watchers_count.to_s if projects_watchers_count > 0
        projects_text << " comments: " + projects_comments_count.to_s if projects_comments_count > 0
        projects_text << " jobs: " + projects_jobs_count.to_s  if projects_jobs_count > 0
      end

      applications_count = current_user.recent_applications_for_jobs_count
      
      applications_text = applications_count > 0 ? " JOB APPLICATIONS: " + applications_count.to_s : ""
      


#      # count WATCHED various idea stats    
#      watched_ideas_projects_count    = current_user.recent_projects_from_watched_ideas_count
#      watched_ideas_interested_count  = current_user.recent_interests_in_watched_ideas_count
#      watched_ideas_watchers_count    = current_user.recent_watchlists_for_watched_ideas_count
#      watched_ideas_comments_count    = current_user.recent_comments_on_watched_ideas_count

#      watched_ideas_text = ""
#      if ((watched_ideas_projects_count + watched_ideas_interested_count + watched_ideas_watchers_count + watched_ideas_comments_count) > 0)
#        watched_ideas_text = " <b>IDEAS |</b>"
#        watched_ideas_text << " projects:" + ideas_projects_count.to_s if ideas_projects_count > 0
#        watched_ideas_text << " interested:" + ideas_interested_count.to_s if ideas_interested_count > 0
#        watched_ideas_text << " watchers:" + ideas_watchers_count.to_s if ideas_watchers_count > 0
#        watched_ideas_text << " comments:" + ideas_comments_count.to_s if ideas_comments_count > 0
#      end

      
        
      tmp = ideas_text + projects_text + applications_text
      text = "MY STUFF: " + tmp if tmp.length > 0 
      
    end
  end    
  
end
