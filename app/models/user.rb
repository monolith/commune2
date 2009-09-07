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
  has_many :all_projects, :through => :active_positions, :source => :project, :uniq => true
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

  # WATCHLISTS
  has_many :watchlists, :dependent => :destroy

  # figure out who is watching this user
  has_many :wlists, :as => :watch, :dependent => :destroy, :class_name => "Watchlist"
  has_many :watchers, :through => :wlists, :source => :user

  has_many :sent_messages, :foreign_key => :from_id, :class_name => "Message"
  has_many :received_messages, :foreign_key => :to_id, :class_name => "Message"
  
  has_one :logon, :dependent => :destroy
  
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
  end

  def watching_ideas
    extract_from_watchlist( self.watchlists.find_all_by_watch_type('Idea'))
  end

  def watching_projects
    extract_from_watchlist( self.watchlists.find_all_by_watch_type('Project') )
  end
  
  def watching_users
    extract_from_watchlist( self.watchlists.find_all_by_watch_type('User') )
  end

  def watching_jobs
    extract_from_watchlist( self.watchlists.find_all_by_watch_type('Job') )
  end

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

      x = 4 # starting point
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
    logger.error "\n\n!!!DELETED\n"
    logger.error self.instance_values.to_yaml
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
