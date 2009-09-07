class Interest < ActiveRecord::Base
  belongs_to :user
  belongs_to :interest, :polymorphic => true, :counter_cache => :interested_count


  private
  
  define_index do
    indexes interest_type

    # looks at the posts, with no codnition it seems
    # so, cannot use things like active_ideas and active_projects
    # this means these searches are not the best
    # may need to modify think sphinx to recognize such relationships correctly
    # at this point cannot search things like positions (because cannot search where hired)
    # anothe posible solution is creation of addition tables, instead of logical mapping

    # SHARED BETWEEN IDEAS, PROJECTS
    indexes [ interest.title,
              interest.description,
              interest.user.first_name, interest.user.last_name, interest.user.company, interest.user.login,
              interest.user.locations.location, interest.industries.name]

    # IDEAS
    indexes [ interest.projects.title, interest.projects.description ]

    # PROJECTS
    indexes [ interest.wiki ]
                  
    has user_id, created_at
    set_property :delta => true 

  end

end
