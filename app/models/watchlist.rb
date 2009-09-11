class Watchlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :watch, :polymorphic => true, :counter_cache => :watchers_count


  attr_accessible :watch_id, :watch_type

  private
  
#  define_index do
#    indexes watch_type

#    # looks at the posts, with no codnition it seems
#    # so, cannot use things like active_ideas and active_projects
#    # this means these searches are not the best
#    # may need to modify think sphinx to recognize such relationships correctly
#    # at this point cannot search things like positions (because cannot search where hired)
#    # anothe posible solution is creation of addition tables, instead of logical mapping

#    # SHARED BETWEEN IDEAS, PROJECTS, JOBS
#    indexes [ watch.title, watch.description,
#              watch.user.first_name, watch.user.last_name, watch.user.company, watch.user.login,
#              watch.user.locations.location, watch.industries.name]

#    # IDEAS
#    indexes [ watch.projects.title, watch.projects.description ]

#    # PROJECTS
#    indexes [ watch.wiki, 
#              watch.jobs.title, watch.jobs.description,
#              watch.jobs.general_skills.name, watch.jobs.general_skills.description ]

#    # JOBS
#    indexes [ watch.project.user.first_name, watch.project.user.last_name,
#              watch.project.user.company, watch.project.user.login,
#              watch.user.locations.location, watch.project.user.locations.location,
#              watch.project.description, watch.project.title,
#              watch.general_skills.name, watch.general_skills.description,
#              watch.project.industries.name ]
#    
#    # USERS
#    indexes [ watch.first_name, watch.last_name, watch.company, watch.login,
#              watch.headline, watch.purpose, watch.education, watch.experience,
#              watch.skills, watch.general_skills.name, watch.general_skills.description, 
#              watch.industries.name, watch.locations.location,
#              watch.ideas.title, watch.ideas.description,
#              watch.projects.title, watch.projects.description, watch.projects.wiki ]
#              
#    has user_id, created_at
#    set_property :delta => true 

#  end

  
end
