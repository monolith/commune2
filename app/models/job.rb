class Job < ActiveRecord::Base

  validates_presence_of     :project, :message => "error: a job must be attached to a project.  Please create project and post the job from it"
  validates_presence_of     :description
  validates_presence_of     :title
  validates_presence_of     :general_skills, :message => "error: you must select at least one general skill"
 
  validates_size_of         :title, :maximum => 100
  validates_size_of         :general_skills, :maximum => 5, :message => "error: you cannot select more than 5 general skills"

  belongs_to  :user
  belongs_to  :project
  has_many    :job_applications, :dependent => :destroy
  has_many    :applicants, :through => :job_applications, :source => :user
  has_one     :hired_user, :through => :job_applications, :source => :user, :conditions => "job_applications.hired" 
  has_many    :users_with_offers, :through => :job_applications, :source => :user, :conditions => "job_applications.offered" 

  has_many    :polymorphic_general_skills, :as => :object, :dependent => :destroy
  has_many    :general_skills, :through => :polymorphic_general_skills

  has_many    :wlists, :as => :watch, :dependent => :destroy, :class_name => "Watchlist"
  has_many    :watchers, :through => :wlists, :source => :user

  # the logic for these counters should be looked at in tandem with those in job_application
  after_create :custom_counter_cache_after_create
  before_update :custom_counter_cache_before_update
  before_destroy :custom_counter_cache_before_destroy, :log

  def self.get(conditions, order, page)
     paginate :include => [:user, :project],
              :per_page => 10, :page => page,
              :conditions => conditions,
              :order => order
  end

  def industries
    self.project.industries
  end

  def status
    if active and open
      if users_with_offers.count > 0
        "Offer made"
      else
        "Open"
      end
    elsif active and not open
      "Filled"
    else
      "Inactive"
    end
  end

  def user_application(user)
    self.job_applications.find_by_user_id user.id
  end

  def updated_since?(timestamp)
    updated_at > timestamp # returns true if updated since date, false otherwise
  end

  def author?(author)
    user == author ? true : false
  end


  private

  # THE BELOW COUNTERS ARE MEANT TO TRACK OPEN JOBS POSTED BY USER
  # AS WELL AS OPEN JOBS FOR A PROJECT
  # NOTE: whether someone has been hired
  # is taken care of in the job_application model (that users project count, and project's member count)

  def custom_counter_cache_after_create
    if active and open
      # this was counted in user's idea counter
      # note: inactive projects are not counted
      increment_active_job_counters
    end
  end
  
  def custom_counter_cache_before_update
    if active_changed? or open_changed?
      if active and open
        # either became active or open
        # if open, someone quit or was fired
        increment_active_job_counters
      else
        # either became inactive or closed
        # if closed, someone was accepted the job (was hired)
        decrement_active_job_counters      
      end
    end
  end
  
  def custom_counter_cache_before_destroy
    if active and open
      # this was counted in user's idea counter
      # note: inactive projects are not counted
      # note: if job is destroyed, so will associated job applications
      decrement_active_job_counters
    end
  end

  def increment_active_job_counters
    # job poster
    user.scorecard.increment! :active_jobs_count
    if project # for future, in case job is created without idea
      project.scorecard.increment! :active_jobs_count
    end
  end

  def decrement_active_job_counters
    # job poster
    user.scorecard.decrement! :active_jobs_count        
    
    if project # for future, in case job is created without idea
      # project
      project.scorecard.decrement! :active_jobs_count
    end
  end
  
  def log
    logger.error "\n\n!!!DELETED\n"
    logger.error self.instance_values.to_yaml
    logger.error "DELETED!!!\n\n"
  end


  define_index do
    indexes title
    indexes description
    indexes [project.members.first_name, project.members.last_name, project.members.company, project.members.login], :as => :members
    indexes [user.locations.location, project.user.locations.location], :as => :location
    indexes [project.description, project.title, project.wiki], :as => :project
    indexes [general_skills.name, general_skills.description], :as => :skills
    indexes project.industries.name, :as => :industries

    has user_id, created_at, watchers_count

    where "jobs.active = true and jobs.open = true" # search only active ideas
    set_property :delta => true 
  end

end
