class Project < ActiveRecord::Base
  validates_presence_of  :title
  validates_size_of :title, :maximum => 100
  
  validates_presence_of  :description
  validates_size_of      :description, :maximum => 1000

  validates_presence_of  :industries, :message => "error: you must select at least one relevant industry"
  validates_size_of      :industries, :maximum => 5, :message => "error: you cannot select more than 5 industries"

  
  acts_as_commentable

  belongs_to :user
  belongs_to :idea
  
  has_many :jobs, :dependent => :destroy
  has_many :open_jobs, :class_name => "Job", :conditions => "jobs.active and jobs.open"
  has_many :job_applications
  has_many :filled_positions, :class_name => "JobApplication", :include => [:user], :conditions => "job_applications.hired and users.active"
  has_many :members, :through => :filled_positions, :source => :user, :uniq => true


  has_one :scorecard, :as => :scorable, :dependent => :destroy

  has_many :wlists, :as => :watch, :class_name => "Watchlist", :dependent => :destroy
  has_many :watchers, :through => :wlists, :source => :user

  has_many :interests, :as => :interest,  :dependent => :destroy
  has_many :interested, :through => :interests, :source => :user

  has_many :relevant_industries, :as => :industrial, :dependent => :destroy
  has_many :industries, :through => :relevant_industries
  
  after_create :generate_scorecard, :add_user_as_project_manager, :custom_counter_cache_after_create
  before_update :custom_counter_cache_before_update
  before_destroy :custom_counter_cache_before_destroy, :log



  attr_accessible :title,
                  :description,
                  :active,
                  :idea_id,
                  :wiki


  def self.get(conditions, order, page)
     paginate :include => [:scorecard, :user ],
              :per_page => 10, :page => page,
              :conditions => conditions,
              :order => order
  end
    
  def locations
    self.user ? self.user.locations : [ Location.new(:location => 'Unknown') ]
  end

  def location_string
      loc = String.new
      self.locations.each do |location| 
        loc << " " << location.location << " |"
      end            
      loc.chop.strip    
  end
  
  def industries_string
      ind = String.new
      self.industries.each do |industry| 
        ind << " " << industry.name << " |"
      end            
      ind.chop.strip
  end

  def author?(author)
    # used for rating?
    user == author ? true : false
  end

  def attach_comment(comment, commentator)      
      self.comments.create :comment => comment, :user => commentator
  end


  def watchers_since(timestamp)
    wlists.count :conditions => "watchlists.created_at > timestamp('" + timestamp.to_s + "')"
  end
  
  def interested_since(timestamp)
    interests.count :conditions => "interests.created_at > timestamp('" + timestamp.to_s + "')"
  end
    
  def comments_since(timestamp)
    comments.count :conditions => "comments.created_at > timestamp('" + timestamp.to_s + "')"    
  end
  
  def jobs_since(timestamp)
    jobs.count :conditions => "jobs.created_at > timestamp('" + timestamp.to_s + "') and jobs.active = true and jobs.open = true"
  end

  def members_since(timestamp)
    filled_positions.count :conditions => "job_applications.updated_at > timestamp('" + timestamp.to_s + "')"
  end
  
  def updated_since?(timestamp)
    updated_at > timestamp # returns true if updated since date, false otherwise
  end



  def self.recent(how_many = 3) # default is 3
    # this is a class method
    # usage => Project.recent(5)
    
    find :all,  :limit => how_many.to_i, :include => :user,
                :conditions => 'projects.active = true and users.activation_code is Null',
                :order => "projects.created_at DESC"
  end    

protected


  def add_user_as_project_manager
      # add poster as project manager
      # this method is call back after create
      add_team_member! :member => self.user, # person who just posted the project
                       :title => "Project Manager",
                       :description => "Original project founder",
                       :message => "Auto generated during project creation"
  end
  

  def add_team_member!(args)
    # this methods only works if job and job_application do not validate presense of parent  
    # need to address the above since code changed
    
    # this method will add a job and job application
    
    user = args[:user] || self.user
    member = args[:member]
    title = args[:title] || "Unknown job"
    description = args[:description] || "Description missing"
    message = args[:message] || "Created through model"

    unless user and user.class == User and member and member.class == User
      return false
    end

    # will default user's skills as skills needed for job, if no skills passed
    if member.general_skills.count > 0
      skills = member.general_skills
    else
      skills = GeneralSkill.find_by_name "Judgement and decision making"
    end

    job=user.jobs.new :project_id => self.id,
                      :title => title,
                      :description => description,
                      :open => false
  
    job.general_skills << skills 
    
    if job.save(false)
      job_application = job.job_applications.new  :user => member,
                                                  :hired => true,
                                                  :message => message,
                                                  :project => self
      job_application.save!
    else
      return false
    end
      
  end



  private
  
  def generate_scorecard
    self.create_scorecard
  end
  
  def custom_counter_cache_after_create
    if active
      # this was counted in user's idea counter
      # note: inactive projects are not counted
      increment_idea_counter
    end
  end
  
  def custom_counter_cache_before_update
    if self.active_changed?
      if self.changes.fetch("active")[1] # fetch returns an array of [previous value, new value]
        # if true, that means active column has changed and is now TRUE (active)
        # increase counter
        increment_idea_counter
        increment_member_counters
      else
        # else, active column has changed and is now FALSE
        # reduce counter
        decrement_idea_counter
        decrement_member_counters
      end
    end
  end 
  
  def custom_counter_cache_before_destroy
    if active
      # this was counted in user's idea counter
      # note: inactive projects are not counted
      decrement_idea_counter
    end
  end

  def increment_member_counters  
    # project members
    members.all.each do |person|
      person.scorecard.increment! :active_projects_count        
    end
  end

  def increment_idea_counter     
    if idea # because project may be created without idea
      idea.scorecard.increment! :active_projects_count
    end
  end

  def decrement_member_counters
    # project members
    members.all.each do |person|
      person.scorecard.decrement! :active_projects_count        
    end
  end
  
  def decrement_idea_counter 
    if idea # because project may be created without idea
      idea.scorecard.decrement! :active_projects_count
    end
  end

  def log
    logger.error "\n\n!!!DELETED PROJECT\n"
    logger.error self.attributes.to_yaml
    logger.error "DELETED!!!\n\n"
  end

  define_index do
    indexes title
    indexes description
    indexes wiki
    indexes comments.comment, :as => :comment_content
    indexes [members.first_name, members.last_name, members.company, members.login], :as => :members
    indexes industries.name, :as => :industries
    indexes [idea.title, idea.description], :as => :idea
    indexes [open_jobs.title, open_jobs.description], :as => :jobs
    indexes members.locations.location, :as => :locations
    indexes scorecard.scorable_type

    # need to add something for geo search

    has user_id, created_at, watchers_count, interested_count
    has scorecard.adjusted_rating

    where "projects.active = true" # search only active project
    set_property :delta => true

  end

end
