class Scorecard < ActiveRecord::Base
  include Math
  belongs_to :scorable, :polymorphic => true
  has_many :ratings
  
  validates_presence_of     :scorable_id
  validates_presence_of     :scorable_type

  attr_accessible # nothing


  def adjust_rating
   
    self.average = self.ratings.average(:stars) || 0
    self.adjusted_rating = self.average * self.average * Math.log(self.ratings.count+1)
    
    if self.scorable_type == 'Idea' || self.scorable_type == 'Project'
    self.adjusted_rating += (Math.log([self.scorable.interested_count-2, 1].max) + Math.log([self.scorable.watchers_count - self.scorable.interested_count - 4, 1].max) ) ** 2
     
    end    
  
    self.save

  end


  def blank?
    scores = average + ratings_count + adjusted_rating + total_comments_count + active_ideas_count \
             + active_projects_count + active_jobs_count
    
    # scorecard is considered blank if there are no scores yet
    scores > 0 ? false : true
  end


  def self.recent(how_many = 3) # default is 3
    # this is a class method
    # usage => Scorecard.recent(5)
    
    # find 3 most recent ideas and or proects
    # (also ensures how_many is an integer)
    scores = find :all, :limit => how_many.to_i, :order => "created_at DESC", :conditions => { :scorable_type => ["Idea", "Project"] }
    
    # return the objects, not scorecard
    items =[]
    if scores
      scores.each do |s|
        items << s.scorable
      end
    end
        
    return items
  end    

  define_index do
    indexes scorable_type
    has adjusted_rating

    set_property :delta => true 
  end
  
end

