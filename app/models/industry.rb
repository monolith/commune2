class Industry < ActiveRecord::Base
  validates_presence_of     :name
  validates_uniqueness_of   :name

  has_many :relevant_industries, :dependent => :destroy

  attr_accessible # nothing should be modified
  
  def self.update_industries( args )
  # THIS ENTIRE THING IS REALLY A HACK
  # FOR WHATEVER REASONS VALIDATIONS DO NOT WORK RIGHT
  # THIS IS TO MAKE SURE THAT THE INDUSTRIES DO NOT GET SAVED UNLESS WITHIN RANGE
  
    object = args[:object]
    industry_ids = args[:industry_ids] || [] # ids should be passed in an array, as integers

    min = 1 # object.class == User ? 0 : 1
    max = 5
    
    if industry_ids.size >= min and industry_ids.size <= max # HACK NEED TO CLEAN UP
    # the reason for checking count here is some issue with saving more than 5
    # although the object has a validation to check if more than 5 have been created
    # and saving the object will through an error
    # for some reason relevant_industries will still be saved
    # this saved even when using a transaction
    
      object.industry_ids = industry_ids
      return true # success
    else
      what = object.class == User ? "interests" : "industries"        
      object.errors.add(what, " should be between #{ min } and #{ max }.")
      return false # failed (more than 5)
    end
  end
  
end
