class Idea < ActiveRecord::Base
  validates_presence_of  :title
  validates_presence_of  :description
  validates_presence_of  :industries, :message => "should be selected"
  validates_size_of      :industries, :maximum => 5, :message => "should not be more than 5."

  acts_as_commentable

  belongs_to :user
  has_many :projects
  has_many :active_projects, :class_name => "Project", :conditions => "projects.active"

  has_one :scorecard, :as => :scorable, :dependent => :destroy

  has_many :wlists, :as => :watch, :class_name => "Watchlist", :dependent => :destroy
  has_many :watchers, :through => :wlists, :source => :user

  has_many :interests, :as => :interest,  :dependent => :destroy
  has_many :interested, :through => :interests, :source => :user

  has_many :relevant_industries, :as => :industrial, :dependent => :destroy
  has_many :industries, :through => :relevant_industries

  after_create :generate_scorecard, :custom_counter_cache_after_create
  before_update :custom_counter_cache_before_update
  before_destroy :custom_counter_cache_before_destroy, :log


  attr_accessible :title,
                  :description,
                  :active


  def self.get(conditions, order, page)
     paginate :include => [:user, :scorecard],
              :per_page => 10, :page => page,
              :conditions => conditions,
              :order => order
  end

  def author?(author)
    # used for rating
    user == author ? true : false
  end

  def attach_comment(comment, commentator)
    self.comments.create( :comment => comment, :user => commentator )
  end
    
  def locations
    self.user ? self.user.locations : [ Location.new(:location => 'Unknown') ]
  end

  def location_string
      loc = String.new
      self.locations.each do |location| 
        loc << " " << location.location + " |"
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

  def watchers_since(timestamp)
    wlists.count :conditions => "watchlists.created_at > timestamp('" << timestamp.to_s << "')"
  end
  
  def interested_since(timestamp)
    interests.count :conditions => "interests.created_at > timestamp('" << timestamp.to_s << "')"
  end
  
  def projects_since(timestamp)
    projects.count :conditions => "projects.created_at > timestamp('" << timestamp.to_s << "') and projects.active = true"
  end
  
  def comments_since(timestamp)
    comments.count :conditions => "comments.created_at > timestamp('" << timestamp.to_s << "')"    
  end
  
  def updated_since?(timestamp)
    updated_at > timestamp # returns true if updated since date, false otherwise
  end
  


  private

  def generate_scorecard
    self.create_scorecard
  end


  def custom_counter_cache_after_create
    if active
      # this was counted in user's idea counter
      # note: inactive projects are not counted
      increment_counter
    end
  end
  
  def custom_counter_cache_before_update

    if self.active_changed? && user
      if self.changes.fetch("active")[1] # fetch returns an array of [previous value, new value]
        # if true, that means active column has changed and is now TRUE (active)
        # increase counter
        increment_counter
      else
        # else, active column has changed and is now FALSE
        # reduce counter
        decrement_counter
      end
    end
  end 
  
  def custom_counter_cache_before_destroy
    if active
      # this was counted in user's idea counter
      # note: inactive projects are not counted
      decrement_counter
    end
  end

  def increment_counter  
    user.scorecard.increment! :active_ideas_count
  end
  
  def decrement_counter
    user.scorecard.decrement! :active_ideas_count
  end

  def log
    logger.error "\n\n!!!DELETED IDEA\n"
    logger.error self.attributes.to_yaml
    logger.error "DELETED!!!\n\n"
  end


  define_index do
    indexes title
    indexes description
    indexes comments.comment, :as => :comment_content
    indexes [user.first_name, user.last_name, user.company, user.login], :as => :author
    indexes industries.name, :as => :industries
    indexes [active_projects.title, active_projects.description], :as => :projects
    indexes user.locations.location, :as => :locations
    indexes scorecard.scorable_type

    # need to add something for geo search

    has user_id, created_at, watchers_count
    has scorecard.adjusted_rating
    has scorecard.active_projects_count, :as => :active_projects_count

    where "ideas.active = true" # search only active ideas

    set_property :delta => true 
  end



end
