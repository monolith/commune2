
require 'digest/sha1'

class User < ActiveRecord::Base

  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,     :message => "has already been taken, perhaps you already registered."
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  validates_format_of       :first_name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :first_name,     :maximum => 30, :allow_nil => true

  validates_format_of       :last_name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :last_name,     :maximum => 30, :allow_nil => true

  validates_format_of       :company,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :company,     :maximum => 50, :allow_nil => true

  validates_format_of       :headline,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :headline,     :maximum => 50, :allow_nil => true

  validates_length_of       :secondary_email, :allow_blank => true, :within => 6..100
  validates_uniqueness_of   :secondary_email,   :allow_blank => true, :message => "has been used for another account."
  validates_format_of       :secondary_email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message, :allow_blank => true

  validates_length_of       :skills,    :within => 0..250, :allow_nil => true
  validates_length_of       :purpose,    :within => 0..500, :allow_nil => true

  validates_length_of       :experience,    :within => 0..4000, :allow_nil => true
  validates_length_of       :education,    :within => 0..1000, :allow_nil => true

  validates_associated      :locations, :message => "must be unique (cannot have two of the same)."
  validates_presence_of     :locations, :message => "error: you must have at least one location."

  # may also want to require general skills and industries, but need to add at sign up
  # only reason not to add now has been to reduce complexity of registration
  # however, the industry and general_skills models, through update, will require addition of these
  validates_size_of         :general_skills, :maximum => 5, :message => "error: you cannot select more than 5 general skills."
  validates_size_of         :relevant_industries, :maximum => 5, :message => "error: you cannot select more than 5 interests."

  has_many :invitations, :dependent => :destroy
  has_many :ideas
  has_many :active_ideas, :class_name => "Idea", :conditions => "ideas.active"

  has_many :projects
  has_many :comments

  has_many :jobs, :dependent => :destroy
  has_many :job_applications, :dependent => :destroy
  has_many :jobs_applied, :through => :job_applications, :source => :job
  has_many :job_openings, :class_name => "Job", :conditions => "jobs.active and jobs.open"

  has_many :positions, :class_name => "JobApplication", :conditions => "job_applications.hired"
  has_many :all_projects, :through => :positions, :source => :project, :uniq => true

  has_many :active_positions, :class_name => "JobApplication", :include => :project, :conditions => "job_applications.hired and projects.active"
  has_many :active_projects, :through => :active_positions, :source => :project, :uniq => true

 
  has_many :ratings
  has_one  :scorecard, :as => :scorable, :dependent => :destroy
  has_many :interests, :dependent => :destroy

  has_many :polymorphic_general_skills, :as=> :object, :dependent => :destroy
  has_many :general_skills, :through => :polymorphic_general_skills

  has_many :relevant_industries, :as => :industrial, :dependent => :destroy
  has_many :industries, :through => :relevant_industries

  has_many :locations, :as => :located, :dependent => :destroy
  has_many :user_locations, :dependent => :destroy

  has_many :sent_messages, :foreign_key => :from_id, :class_name => "Message"
  has_many :received_messages, :foreign_key => :to_id, :class_name => "Message"
  
  has_one :logon, :dependent => :destroy # keep track of last logon

  # WATCHLISTS
  has_many :watchlists, :dependent => :destroy
  # figure out who is watching this user
  has_many :wlists, :as => :watch, :dependent => :destroy, :class_name => "Watchlist"
  has_many :watchers, :through => :wlists, :source => :user

  # for dashboard - watched ideas
  has_many :watched_ideas, :through => :watchlists, :source => :watch, :source_type => "Idea", :conditions => "ideas.active"

  # THESE SQL STATEMENTS ARE NEEDED BECAUSE THE HAS_MANY THROUGH DOES NOT WORK FOR THESE CORRECTLY (too many JOINS needed)

  has_many :watched_ideas_recent_projects, :class_name => 'Project', :finder_sql =>  'select distinct `projects`.* from `projects` JOIN `ideas` ON `ideas`.id = `projects`.idea_id JOIN `watchlists` ON `watchlists`.watch_id = `ideas`.id and `watchlists`.watch_type = \'Idea\' JOIN `users` ON `users`.id = `watchlists`.user_id WHERE `users`.id = #{id} and `projects`.active and `projects`.created_at > \'#{logon.previous.to_time}\' ORDER BY `projects`.created_at DESC'


  # for dashboard - watched projects
  has_many :watched_projects, :through => :watchlists, :source => :watch, :source_type => "Project", :conditions => "projects.active"

  has_many :watched_projects_recent_jobs, :class_name => 'Job', :finder_sql =>  'select distinct `jobs`.* from `jobs` JOIN `watchlists` ON `watchlists`.watch_id = `jobs`.project_id and `watchlists`.watch_type = \'Project\' JOIN `users` ON `users`.id = `watchlists`.user_id WHERE `users`.id = #{id} and `jobs`.open and `jobs`.active AND `jobs`.created_at > \'#{logon.previous.to_time}\' ORDER BY `jobs`.created_at DESC'


  has_many :watched_jobs, :through => :watchlists, :source => :watch, :source_type => "Job"
  
  # for dashboard - watched people
  has_many :watched_people, :through => :watchlists, :source => :watch, :source_type => "User", :conditions => "users.active"
  
  has_many :watched_people_ideas, :class_name => 'Idea', :finder_sql =>  'select distinct `ideas`.* from `ideas` JOIN `watchlists` ON `watchlists`.watch_id = `ideas`.user_id and `watchlists`.watch_type = \'User\' JOIN `users` ON `users`.id = `watchlists`.user_id WHERE `users`.id = #{id} AND `ideas`.created_at > \'#{logon.previous.to_time}\' ORDER BY `ideas`.created_at DESC'

  has_many :watched_people_projects, :class_name => 'Project',
      :finder_sql =>  'select distinct `projects`.* from `projects` JOIN `job_applications` ON `projects`.id = `job_applications`.project_id JOIN         `watchlists` ON `watchlists`.watch_id = `job_applications`.user_id and `watchlists`.watch_type = \'User\' JOIN `users` ON `users`.id = `watchlists`.user_id JOIN `jobs` ON `jobs`.id = `job_applications`.job_id WHERE `users`.id = #{id} and `job_applications`.hired and `projects`.active and `jobs`.active and `projects`.created_at > \'#{logon.previous.to_time}\' ORDER BY `projects`.created_at DESC',
      
      :counter_sql => 'select count(distinct `projects`.id) from `projects` JOIN `job_applications` ON `projects`.id = `job_applications`.project_id JOIN `watchlists` ON `watchlists`.watch_id = `job_applications`.user_id and `watchlists`.watch_type = \'User\' JOIN `users` ON `users`.id = `watchlists`.user_id JOIN `jobs` ON `jobs`.id = `job_applications`.job_id WHERE `users`.id = #{id} and `job_applications`.hired and `projects`.active and `jobs`.active and `projects`.created_at > \'#{logon.previous.to_time}\' ORDER BY `projects`.created_at DESC'

  has_many :watched_people_recent_jobs, :class_name => 'Job', :finder_sql =>  'select distinct `jobs`.* from `jobs` JOIN `watchlists` ON `watchlists`.watch_id = `jobs`.user_id and `watchlists`.watch_type = \'User\' JOIN `users` ON `users`.id = `watchlists`.user_id WHERE `users`.id = #{id} and `jobs`.open and `jobs`.active AND `jobs`.created_at > \'#{logon.previous.to_time}\' ORDER BY `jobs`.created_at DESC'

  # USER'S DASHBOARD STATS
  # stats on ideas  
  has_many :comments_on_ideas, :through => :active_ideas, :source => :comments
  has_many :watchlists_for_ideas, :through => :active_ideas, :source => :wlists
  has_many :interests_in_ideas, :through => :active_ideas, :source => :interests
  has_many :projects_from_ideas, :through => :active_ideas, :source => :projects
  # stats on projects  
  has_many :comments_on_projects, :through => :active_projects, :source => :comments
  has_many :watchlists_for_projects, :through => :active_projects, :source => :wlists
  has_many :interests_in_projects, :through => :active_projects, :source => :interests
  # stats on jobs
  has_many :applications_for_jobs, :through => :job_openings, :source => :job_applications, :conditions => "job_applications.user_id != #{id}"


  before_create :make_activation_code
  after_create :create_some_objects
  before_update :custom_counter_cache_before_update
  before_destroy :log   # decreaseing active member count on projects not needed
                        # because this will be handled through destroy of job application

  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login,
                  :email,
                  :secondary_email,
                  :first_name,
                  :last_name,
                  :company,
                  :headline,
                  :skills,
                  :purpose,
                  :experience,
                  :education,
                  :no_cash_ok,
                  :currently_available,
                  :individual,
                  :active,
                  :password,
                  :password_confirmation,
                  :last_logon,
                  :previous_logon


  def self.get(conditions, order, page)
     paginate :include => [ :scorecard ],
              :per_page => 10, :page => page,
              :conditions => conditions,
              :order => order
  end

  # Activates the user in the database.
  def activate!

    now = Time.now.utc
    @activated = true
    self.activated_at = now
    self.activation_code = nil
    self.active = true # needed because default when registering is false to prevent
                       # the profile from coming up in search results, etc
    save(false)

    logon.previous = logon.last = now
    logon.save(false)

  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['(login = ? or email = ?) and activated_at IS NOT NULL', login, login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end


  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  def reset_password
    # First update the password_reset_code before setting the
    # reset_password flag to avoid duplicate mail notifications.
    update_attributes(:password_reset_code => nil)
    @reset_password = nil
  end

  # Used in user_observer
  def recently_forgot_password?
    @forgotten_password
  end

  # Used in user_observer
  def recently_reset_password?
    @reset_password
  end

  # Used in user_observer
  def recently_activated?
    @activated
  end

  def author?(author)
    # this for rating.  name of method needs to be renamed for profiles, but initially done for ideas and projects
    self == author ? true : false
  end

  def name
    f = self.first_name || ""
    l = self.last_name || ""
    f + " " + l
    f.strip
  end


#  def watching_ideas
#    extract_from_watchlist( self.watchlists.find_all_by_watch_type('Idea'))
#  end

#  def watching_projects
#    extract_from_watchlist( self.watchlists.find_all_by_watch_type('Project') )
#  end
#  
#  def watching_users
#    extract_from_watchlist( self.watchlists.find_all_by_watch_type('User') )
#  end

#  def watching_jobs
#    extract_from_watchlist( self.watchlists.find_all_by_watch_type('Job') )
#  end

  def interested_ideas
    extract_from_interests( self.interests.find_all_by_interest_type('Idea') )
  end

  def interested_projects
    extract_from_interests( self.interests.find_all_by_interest_type('Project') )
  end

  def updated_since?(timestamp)
    updated_at > timestamp # returns true if updated since date, false otherwise
  end
    
  def comments_since(timestamp)
    comments.count :conditions => "comments.created_at > timestamp('" + timestamp.to_s + "')"    
  end
  
  def jobs_since(timestamp)
    jobs.count :conditions => "jobs.created_at > timestamp('" + timestamp.to_s + "') and jobs.active = true and jobs.open = true"
  end

  def ideas_since(timestamp)
    ideas.count :conditions => "ideas.created_at > timestamp('" + timestamp.to_s + "') and ideas.active = true"
  end

  def projects_since(timestamp)
    # this coun includes projects user posted and also project onto which the user has been hired
    positions.count :include => :project, :conditions => "projects.created_at > timestamp('" + timestamp.to_s + "') and projects.active = true"
  end

  def available_invitations
    if admin
      # unlimitted invitations for admin
      1000 # 1000 will always be display as a constant.. unless some addition logic is added
    else

      x = 2 # starting point
      # minus number of invites in 24 hours (86400 seconds)
      x -= invitations.count :conditions =>  ["created_at > ?", Time.now.utc - 86400 ]
      # return x or 0, which ever is greater
      x > 0 ? x : 0 
      
    end
  end


  def to_param
    login
  end

  def logged_in_now!
    now = Time.now.utc

    if ((now - logon.last) / 3600) > 24 # check if 24 hours past since last update
      logon.previous = logon.last
      logon.last = now
      logon.save(false)
    end
  end

 
  def admin?
    admin
  end


  # stuff for user's dashboard
  def recent_comments_on_ideas_count
     self.comments_on_ideas.count :conditions => ["comments.created_at > ?", self.logon.previous]
  end

  def recent_watchlists_for_ideas_count
     self.watchlists_for_ideas.count :conditions => ["watchlists.created_at > ?", self.logon.previous]
  end

  def recent_interests_in_ideas_count
     self.interests_in_ideas.count :conditions => ["interests.created_at > ?", self.logon.previous]
  end

  def recent_projects_from_ideas_count
     self.projects_from_ideas.count :conditions => ["projects.created_at > ?", self.logon.previous]
  end

  def recent_comments_on_projects_count
     self.comments_on_projects.count :conditions => ["comments.created_at > ?", self.logon.previous]
  end

  def recent_watchlists_for_projects_count
     self.watchlists_for_projects.count :conditions => ["watchlists.created_at > ?", self.logon.previous]
  end

  def recent_interests_in_projects_count
     self.interests_in_projects.count :conditions => ["interests.created_at > ?", self.logon.previous]
  end

  
  def recent_applications_for_jobs_count
     self.applications_for_jobs.count :conditions => ["job_applications.created_at > ?", self.logon.previous]
  end
 



  def dashboard_stats

    # really need to optimize this logic to reduce number of queries
    
    mystuff ={}
    watching ={}

    # user's own stuff    
    mystuff[:ideas] = {
      :recent_comments => recent_comments_on_ideas_count,
      :recent_watching => recent_watchlists_for_ideas_count,
      :recent_interested => recent_interests_in_ideas_count,
      :recent_projects => recent_projects_from_ideas_count }

    mystuff[:projects] = {
      :recent_comments => recent_comments_on_projects_count,
      :recent_watching => recent_watchlists_for_projects_count,
      :recent_interested => recent_interests_in_projects_count }

    mystuff[:jobs] = {
      :recent_applications => recent_applications_for_jobs_count }
      
    mystuff[:totals] = {
      :recent_comments => mystuff[:ideas][:recent_comments] + mystuff[:projects][:recent_comments],
      :recent_watching => mystuff[:ideas][:recent_watching] + mystuff[:projects][:recent_watching],
      :recent_interested => mystuff[:ideas][:recent_interested] + mystuff[:projects][:recent_interested],
      :recent_projects => mystuff[:ideas][:recent_projects],
      :recent_applications => mystuff[:jobs][:recent_applications]
    }


    # watchlist stuff (things user is watching)
    # based on associations
    w_ideas_projects = watched_ideas_recent_projects
    w_projects_jobs = watched_projects_recent_jobs
    w_people_ideas = watched_people_ideas
    w_people_projects = watched_people_projects
    w_people_jobs = watched_people_recent_jobs

    watching[:ideas] = {
      :recent_projects => w_ideas_projects.size }

    watching[:projects] = {
      :recent_jobs => w_projects_jobs.size }

    watching[:people] = {
      :recent_ideas => w_people_ideas.size,
      :recent_projects => w_people_projects.size,
      :recent_jobs => w_people_jobs.size }
      
    watching[:totals] = {
      :recent_jobs => (w_projects_jobs | w_people_jobs).size,
      :recent_projects => (w_ideas_projects | w_people_projects).size,
      :recent_ideas => watching[:people][:recent_ideas]
    }

        
    return { :mystuff => mystuff, :watching => watching }  
  end
  
 
  protected

  def create_some_objects
    self.create_scorecard
    self.create_logon
  end

  def make_activation_code

    self.activation_code = self.class.make_token
  end

  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end


  # need to use an association with source_type instead
  def extract_from_watchlist(list)
    stuff = []
    list.each do |item|
      stuff << item.watch unless item.watch.nil?
    end
    stuff      
  end

  def extract_from_interests(list)
    stuff = []
    list.each do |item|
      stuff << item.interest unless item.interest.nil?
    end
    stuff      
  end


  private

  def log
    logger.error "\n\n!!!DELETED USER\n"
    logger.error self.attributes.to_yaml
    logger.error "DELETED!!!\n\n"
  end

  # note before destroy is not needed because this will be handled through destroy of job application
  def custom_counter_cache_before_update
    # ensuring that active_members count is updated correctly
    if self.active_changed?
      if active
        # increase active members count on projects
        increment_projects_members_counter
      else
        # became inactive - need do decrease active member count on projects
        decrement_projects_members_counter
      end
    end
  end 
  
  def increment_projects_members_counter
    all_projects.each { |project| project.scorecard.increment! :active_members_count }    
  end

  def decrement_projects_members_counter
    all_projects.each { |project| project.scorecard.decrement! :active_members_count }
  end


  define_index do
    indexes [first_name, last_name, company, login], :as => :person
    indexes headline    
    indexes purpose    
    indexes education
    indexes experience
    indexes skills
    indexes [general_skills.name, general_skills.description], :as => :general_skills
    indexes industries.name, :as => :industries
    indexes locations.location, :as => :locations
    indexes [active_projects.title, active_projects.description, active_projects.wiki], :as => :projects
    indexes [active_ideas.title, active_ideas.description], :as => :ideas
    indexes [active_positions.job.title, active_positions.job.description], :as => :positions
    indexes [job_openings.title, job_openings.description], :as => :jobs
    indexes scorecard.scorable_type

    has logon.last, :as => :last_logon
    has watchers_count, created_at
    has scorecard.adjusted_rating, :as => :adjusted_rating

    # for geosearch see user_location

    where "users.active = true and activated_at > 0" # search only activated users
    set_property :delta => true 

  end


end
